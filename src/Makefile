EXTRA_CFLAGS	+= -Wall -Wno-deprecated-declarations	\
		   -I$(src)		\
		   -I$(src)/common $(DNI_KMOD_CFLAGS)

EXTRA_CFLAGS    += -DQTN_TX_SKBQ_SUPPORT -DQTN_WAKEQ_SUPPORT

PWD	:= $(shell pwd)

COMMON_DIR	:= ./common
qdpc-host-objs   := $(COMMON_DIR)/qdpc_init.o $(COMMON_DIR)/qdpc_pcie.o $(COMMON_DIR)/topaz_vnet.o qdpc_platform.o
obj-${CONFIG_QDPC_HOST}           +=  qdpc-host.o

qdpc_host.o: $(qdpc-host-objs)
	ld -r $^ -o $@
