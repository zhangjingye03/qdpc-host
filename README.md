# qdpc-host

## Introduction

This is a quick 'n' dirty package for OpenWrt Desinated Driver ipq806x targets (e.g. Netgear R7500v1) to communicate with Quantenna chip (QT3840) by using PCIE.

However it is still **NOT WORKING** and need further fix. (I think it is caused by different kernel version as GPL code is for 3.4 or older.)

While insmoding, it returns Segmentation Fault as well as kernel log says

```
[57181.643121] parent cap:128, dev cap:256
[57181.643147] Setting MPS to 128
[57181.646204] PCIe MSI Interrupt Enabled
[57181.648880] qdpc_map_sysctl_regs() Mapping sysctl
[57181.652614] Zero length BAR
[57181.657461] Failed bar mapping sanity check in qdpc_map_bar
[57181.659996] qdpc_map_epmem() Mapping epmem
[57181.665700] BAR:2 vaddr=0xd00e0000 busaddr=08000000 offset=0 len=65536
[57181.669720] qdpc_map_dma_regs() Mapping dma registers
[57181.676352] BAR:3 vaddr=0xd0100000 busaddr=08010000 offset=0 len=65536
[57181.681351] qdpc-host version v37.3.1.25 Quantenna Communications Inc.
[57181.687877] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[57181.694370] pgd = cb3a0000
[57181.702525] [00000000] *pgd=4eb46831, *pte=00000000, *ppte=00000000
[57181.711033] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[57181.711385] Modules linked in: qdpc_host(+) pppoe ppp_async iptable_nat pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQ                                                                                         UERADE xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_CT slhc nf_reject_ip                                                                                         v4 nf_nat_masquerade_ipv4 nf_nat nf_log_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack iptable_raw iptable_mangle iptable_filter ip_tables                                                                                          crc_ccitt ath10k_pci ath10k_core ath mac80211 cfg80211 compat ledtrig_usbdev ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common ip6table_raw ip6table_mangle                                                                                          ip6table_filter ip6_tables x_tables leds_gpio xhci_plat_hcd xhci_pci xhci_hcd dwc3 dwc3_qcom ohci_platform ohci_hcd phy_qcom_dwc3 ahci ehci_platform ehci_hcd sd                                                                                         _mod ahci_platform libahci_platform libahci libata scsi_mod gpio_button_hotplug usbcore nls_base usb_common
[57181.795408] CPU: 1 PID: 6003 Comm: insmod Tainted: G    B          3.18.29 #1
[57181.795676] task: c978e400 ti: cbd3e000 task.ti: cbd3e000
[57181.802803] PC is at vmac_net_init+0x98/0x484 [qdpc_host]
[57181.808178] LR is at vmac_net_init+0x30/0x484 [qdpc_host]
[57181.813556] pc : [<bf31570c>]    lr : [<bf3156a4>]    psr: 60000013
[57181.813556] sp : cbd3fd00  ip : 00000000  fp : 00000080
[57181.818945] r10: cb1a94c0  r9 : cd97f800  r8 : 00000078
[57181.830220] r7 : cd97fc00  r6 : 00000000  r5 : 00000000  r4 : cb1a9000
[57181.835432] r3 : 00000000  r2 : 00200001  r1 : 00200001  r0 : 0000003a
[57181.842030] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[57181.848538] Control: 10c5787d  Table: 4d3a006a  DAC: 00000015
[57181.855743] Process insmod (pid: 6003, stack limit = 0xcbd3e238)
[57181.861473] Stack: (0xcbd3fd00 to 0xcbd40000)
[57181.867548] fd00: 00000000 00000000 cd97fc00 cb1a94c0 cd97fc00 cd97fc00 cb1a9000 00000000
[57181.871806] fd20: 00000000 00000078 cd97f800 cb1a94c0 00000080 bf313dc4 00000000 201f2010
[57181.879966] fd40: 00008701 00008000 bf317548 cd97fc68 bf317470 00000000 cd97fc00 bf31743c
[57181.888128] fd60: 0000001c cbc9e040 bf317548 c03c5f10 c07b8ad8 cd97fc68 c07b8ad4 00000000
[57181.896286] fd80: bf317470 c03ffd3c cd97fc68 bf317470 cd97fc9c c0753ca4 bf319000 00000000
[57181.904445] fda0: cbc9e040 c03fff48 00000000 bf317470 c03ffed4 c03fe518 cd8d525c cd9fd7b4
[57181.912606] fdc0: bf317470 cc355500 00000000 c03ff564 bf317430 c0742c48 cbd3e010 bf317470
[57181.920767] fde0: c0742c48 cbd3e010 c073e408 c04005a4 c0742c48 c0742c48 cbd3e010 bf31901c
[57181.928924] fe00: c0742c48 c0742c48 cbd3e010 c02137b8 ccb42380 8040003e 00000000 cbd3e010
[57181.937084] fe20: 00000001 c0736ce0 cdfcf840 8040003e cd801f00 c0736ce0 cdfcf840 c0736ce0
[57181.945244] fe40: cdfcf840 ccb42380 cd801f00 8040003e cde24ce0 c02bfdc4 001931ed c027f1fc
[57181.953405] fe60: 00000001 dc8cb01d cbd3ff58 cbc9e6c8 bf317554 00000001 00000001 cbc9e6c0
[57181.961564] fe80: bf317590 c027f224 bf317554 00007fff c027c488 c021224c ccb42340 00000000
[57181.969723] fea0: c073e408 3436195c cbd3e008 bf317548 bf317690 00000000 0000012c c0655c24
[57181.977884] fec0: d00cd000 bf317248 00000001 c073e418 d00cd000 d00ccfff bf315f9c 00000002
[57181.986044] fee0: 00000000 00000000 00000000 00000000 6e72656b 00006c65 00000000 00000000
[57181.994202] ff00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[57182.002362] ff20: 00000000 00000000 00000000 dc8cb01d c0208f04 000086d4 003b7010 b6f202d0
[57182.010522] ff40: 00000080 c0208f04 cbd3e000 00000000 00000000 c027f858 d00c4000 000086d4
[57182.018683] ff60: d00cbf7c d00c88a2 d00c9d3c 000046b8 000049a8 00000000 00000000 00000000
[57182.026841] ff80: 0000002d 0000002e 00000024 00000000 00000016 00000000 00000000 00000000
[57182.035002] ffa0: 00000003 c0208d80 00000000 00000000 003b7010 000086d4 b6f202d0 0000000c
[57182.043160] ffc0: 00000000 00000000 00000003 00000080 000086d4 00000000 00000020 00000000
[57182.051322] ffe0: be8e1c74 be8e1c58 00011abc b6f723e0 60000010 003b7010 00000000 00000000
[57182.059523] [<bf31570c>] (vmac_net_init [qdpc_host]) from [<bf313dc4>] (qdpc_pcie_probe+0x238/0x31c [qdpc_host])
[57182.067658] [<bf313dc4>] (qdpc_pcie_probe [qdpc_host]) from [<c03c5f10>] (pci_device_probe+0x58/0xa8)
[57182.077898] [<c03c5f10>] (pci_device_probe) from [<c03ffd3c>] (really_probe+0xd4/0x214)
[57182.087004] [<c03ffd3c>] (really_probe) from [<c03fff48>] (__driver_attach+0x74/0x98)
[57182.094814] [<c03fff48>] (__driver_attach) from [<c03fe518>] (bus_for_each_dev+0x4c/0xa0)
[57182.102800] [<c03fe518>] (bus_for_each_dev) from [<c03ff564>] (bus_add_driver+0xd8/0x1f0)
[57182.110962] [<c03ff564>] (bus_add_driver) from [<c04005a4>] (driver_register+0xa8/0xec)
[57182.119126] [<c04005a4>] (driver_register) from [<bf31901c>] (init_module+0x1c/0x80 [qdpc_host])
[57182.126957] [<bf31901c>] (init_module [qdpc_host]) from [<c02137b8>] (do_one_initcall+0x118/0x1f0)
[57182.135972] [<c02137b8>] (do_one_initcall) from [<c027f224>] (load_module+0x188c/0x1df4)
[57182.144729] [<c027f224>] (load_module) from [<c027f858>] (SyS_init_module+0xcc/0xf8)
[57182.152976] [<c027f858>] (SyS_init_module) from [<c0208d80>] (ret_fast_syscall+0x0/0x38)
[57182.160697] Code: e2855001 e1560005 1afffff0 e59451f0 (e5d53000)
[57182.168852] ---[ end trace d98bcb49c1d75a66 ]---
```

Any ideas and advices are appreciated.

## How to use

* Just cd into `/path/to/your/openwrt/package/kernel`

* Clone this repo

* Run `make menuconfig` at OpenWrt root folder, and selects

	Kernel modules --->
		Wireless Drivers --->
			<M> kmod-qdpc-host..................... Quantenna 5GHz Chip PCIE2 Host Drivers

* `make`

* Find qdpc-host.ko and push it into your router.

* `indmod qdpc-host.ko`

* ~~Wait for Segmentation Fault or kernel panic~~ :joy:

## Files I Changed

* `#include <xxx>` changed to `#include "xxx"` in many .c and .h files

* `src/common/nss_api_if.h` : it was missing so I just found one on Github.

* `src/common/topaz_vnet.c`, line 1301: `SET_ETHTOOL_OPS` doesn't support 3.18 kernel. Changed to `ndev->ethtool_ops = &vmac_ethtool_ops;` instead.

* `src/common/topaz_vnet.c`, line 1257: add `NET_NAME_UNKNOWN` to the third argument due to failed compiling `alloc_netdev requires 4 arguments`.

* `src/common/qdpc_init.c`, line 696: remove `machine_restart(NULL);` because of `qdpc_host: Unknown symbol machine_restart (err 0)` while insmoding.

## Where to get official Files

On [Netgear GPL Center](http://kb.netgear.com/app/answers/detail/a_id/2649/~/netgear-open-source-code-for-programmers-(gpl)), download [R7500, 1.0.0.94](http://www.downloads.netgear.com/files/GPL/R7500-and_qtn_gpl_src_V1.0.0.94.zip).

---

At last, many thanks to OpenWrt Forum user `ILOVEPIE` who gave me idea to compile this module.

[Link on OpenWrt Forum](https://forum.openwrt.org/viewtopic.php?id=64195)
