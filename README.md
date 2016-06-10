# qdpc-host

## Introduction

This is a package contains the proprietary wireless driver for the Quantenna chipset on OpenWrt Desinated Driver ipq806x targets (e.g. Netgear R7500v1).

Having suffered from annoying Quantenna GPL source for nearly a week, I finally made it working on Openwrt DD Trunk.

Kernel Log would say something like below if you insmod it.

```
[   36.874755] parent cap:128, dev cap:256
[   36.874778] Setting MPS to 128
[   36.877721] PCIe MSI Interrupt Enabled
[   36.880513] qdpc_map_sysctl_regs() Mapping sysctl
[   36.884481] BAR:0 vaddr=0xd0200000 busaddr=08000000 offset=0 len=1048576
[   36.889024] qdpc_map_epmem() Mapping epmem
[   36.895970] BAR:2 vaddr=0xd0400000 busaddr=08100000 offset=0 len=1048576
[   36.899704] qdpc_map_dma_regs() Mapping dma registers
[   36.906707] BAR:3 vaddr=0xcf660000 busaddr=08210000 offset=0 len=65536
[   36.911508] qdpc-host version v37.3.1.25 Quantenna Communications Inc.
[   36.918180] Tx Descriptor table: uncache virtual addr: 0xce814000 paddr: 0x4f902000
[   36.924573] Rx Descriptor table: uncache virtual addr: 0xce8145a0 paddr: 0x4f9025a0
[   36.931997] EP_handled_idx: uncache virtual addr: 0xce8151a0 paddr: 0x4f9031a0
[   36.941486] host0: Vmac Ethernet found
[   36.951405] device host0 entered promiscuous mode
[   36.951704] br-lan_priv: port 3(host0) entered forwarding state
[   36.955532] br-lan_priv: port 3(host0) entered forwarding state
[   36.992408] PCI memory is little endian
[   36.992435] EP map start addr : 0x00000000, Host memory start : 0x42000000
[   36.995046] Setting HOST ready...
[   37.042399] EP FW load request...
[   37.092434] Start download Firmware u-boot.bin...
[   37.142459] FW Data[0]: VA:0xcf671000 PA:0x4d700000 Sz=70752..
[   37.192432] done!
[   37.242452] Image. Sz:70752 State:0xc
[   37.292404] Image downloaded....!
[   37.292422] Start booting EP...
[   38.952370] br-lan_priv: port 3(host0) entered forwarding state
[   40.452422] PCI memory is little endian
[   40.452448] DMA offset : 0xbe000000, no need to reset the value.
[   40.455059] Setting HOST ready...
[   40.502688] EP FW load request...
[   40.552668] Start download Firmware topaz-linux.lzma.img...
[   40.603640] FW Data[0]: VA:0xd0501000 PA:0x4cb00000 Sz=1048576..
[   40.652666] done!
[   40.653765] FW Data[1]: VA:0xd0601000 PA:0x4cb00000 Sz=1048576..
[   40.702682] done!
[   40.703767] FW Data[2]: VA:0xd0701000 PA:0x4cb00000 Sz=1048576..
[   40.752666] done!
[   40.753759] FW Data[3]: VA:0xd0801000 PA:0x4cb00000 Sz=1048576..
[   40.802681] done!
[   40.803011] FW Data[4]: VA:0xd0901000 PA:0x4cb00000 Sz=322330..
[   40.852664] done!
[   40.902683] Image. Sz:4516634 State:0xc
[   40.953398] Image downloaded....!
[   40.953416] Start booting EP...
```

Then, interface `host0` appears and the QT3840 chip's serial log begins to flow. :-)

* This is only a kernel module. If you want to control WiFi, `qcsapi` is required too. I'll post it later if I can make it work properly.

## How to use

* Just cd into `/path/to/your/openwrt/package/kernel`

* Clone [qca-nss-drv](https://github.com/zhangjingye03/qca-nss-drv) and [qca-nss-gmac](https://github.com/zhangjingye03/qca-nss-gmac) first to support NSS.

* Clone this repo

* Run `make menuconfig` at OpenWrt root folder, and selects

```
	Kernel modules --->
		Quantenna WiFi driver --->
			<M> kmod-qdpc-host..................... Kernel driver for Quantenna chipsets
```

* `make`

* Find `kmod-qdpc-host_x.x.x-xxx.ipk`, `kmod-qca-nss-drv_x.x.x-xxx.ipk`, `kmod-qca-nss-gmac_x.x.x-xxx.ipk` in `bin/ipq806x/packages/kernel` and push it into your router's `/tmp` directory.

* Execute `opkg install /tmp/*.ipk` on your router

* Enjoy

## Files I Changed

* `src/common/nss_api_if.h` : it was missing so I just found one at [here](https://github.com/OpenHUE/bsb002-lklm_nss-drv).

* `src/common/topaz_vnet.c`, line 1301: `SET_ETHTOOL_OPS` doesn't support 3.18 kernel. Changed to `ndev->ethtool_ops = &vmac_ethtool_ops;` instead.

* `src/common/topaz_vnet.c`, line 1257: add `NET_NAME_UNKNOWN` to the third argument due to failed compiling `alloc_netdev requires 4 arguments`.

* `src/common/qdpc_init.c`, line 696: comment `machine_restart(NULL);` out because of `qdpc_host: Unknown symbol machine_restart (err 0)` while insmoding. (P.S. After some searching, someone says that I should compile it into kernel instead of making it a kernel module. I have not tested it yet.)

## Where to get official Files

On [Netgear GPL Center](http://kb.netgear.com/app/answers/detail/a_id/2649/~/netgear-open-source-code-for-programmers-(gpl)), download [R7500, 1.0.0.94](http://www.downloads.netgear.com/files/GPL/R7500-and_qtn_gpl_src_V1.0.0.94.zip).

## Features

### Working

* Qualcomm Network Sub System (NSS) support

* Auto load on boot

### Not working

* 5Ghz LED cannot be used to show WiFi data link because Netgear or Qualcomm or Quantenna changed many places to control LED and it requires a function called `detect_wifi_5g_data`, which appears in Netgear's GPL Source `./git_home/linux.git/sourcecode/drivers/gpio/gpio-msm-common.c`. However you can specify its trigger to netdev and device to host0.

* If something bad happens on Quantenna Chipset (such as kernel panic), ipq8064 cannot restart automatically. (`machine_restart` has been commented out)

* ~~Sometimes the drivers crashed quietly (maybe TX queue full) during large data flows.~~ (qca-nss-drv solves it)

## Lesson I have learnt

* DO NOT use different kernel because the architect in it may vary. I used Openwrt official snapshots version and insmoded my build kernel module to it. Well, lots of strange null pointers, allocation fails, etc. I spent much time to add printk to many places to see where it goes, although no use at all. But when I switch the official firmware to mine, this kernel module works.

* DO NOT always ask others for help. DO IT YOURSELF, and you will find it easier and more interesting.

---

At last, many thanks to OpenWrt Forum user `ILOVEPIE` who gave me idea to compile this module.

[Link on OpenWrt Forum](https://forum.openwrt.org/viewtopic.php?id=64195)
