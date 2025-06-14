/*
 * Copyright 2021-2025 HPMicro
 * SPDX-License-Identifier: BSD-3-Clause
 */

ENTRY(_start)

STACK_SIZE = DEFINED(_stack_size) ? _stack_size : 0x4000;
HEAP_SIZE = DEFINED(_heap_size) ? _heap_size : 144K;
FLASH_SIZE = DEFINED(_flash_size) ? _flash_size : 16M;
NONCACHEABLE_SIZE = DEFINED(_noncacheable_size) ? _noncacheable_size : 0x4000;

MEMORY
{
    XPI0 (rx) : ORIGIN = 0x80000000, LENGTH = FLASH_SIZE
    ILM (wx) : ORIGIN = 0, LENGTH = 128K
    DLM (w) : ORIGIN = 0x80000, LENGTH = 128K
    NONCACHEABLE_RAM (wx) : ORIGIN = 0x01080000, LENGTH = 64K
    AXI_SRAM  (wx) : ORIGIN = 0x01090000, LENGTH = 176K
    SHARE_RAM (w) : ORIGIN = 0x010BC000, LENGTH = 16K
    AHB_SRAM (w) : ORIGIN = 0xF0300000, LENGTH = 32k
}

__nor_cfg_option_load_addr__ = ORIGIN(XPI0) + 0x400;
__boot_header_load_addr__ = ORIGIN(XPI0) + 0x1000;
__app_load_addr__ = ORIGIN(XPI0) + 0x3000;
__boot_header_length__ = __boot_header_end__ - __boot_header_start__;
__app_offset__ = __app_load_addr__ - __boot_header_load_addr__;

SECTIONS
{
    .nor_cfg_option __nor_cfg_option_load_addr__ : {
        KEEP(*(.nor_cfg_option))
    } > XPI0

    .boot_header __boot_header_load_addr__ : {
        __boot_header_start__ = .;
        KEEP(*(.boot_header))
        KEEP(*(.fw_info_table))
        KEEP(*(.dc_info))
        __boot_header_end__ = .;
    } > XPI0

    .start __app_load_addr__ : {
        . = ALIGN(8);
        KEEP(*(.start))
    } > XPI0

    __vector_load_addr__ = ADDR(.start) + SIZEOF(.start);
    .vectors : AT(__vector_load_addr__) {
        . = ALIGN(8);
        __vector_ram_start__ = .;
        KEEP(*(.vector_table))
        KEEP(*(.isr_vector))
        . = ALIGN(8);
        __vector_ram_end__ = .;
    } > ILM

    .fast : AT(etext + __data_end__ - __tdata_start__) {
        . = ALIGN(8);
        __ramfunc_start__ = .;
        *(.fast)

        /* RT-Thread Core Start */
        KEEP(*context_gcc.o(.text* .rodata*))
        KEEP(*port*.o (.text .text* .rodata .rodata*))
        KEEP(*interrupt_gcc.o (.text .text* .rodata .rodata*))
        KEEP(*trap_common.o (.text .text* .rodata .rodata*))
        KEEP(*irq.o (.text .text* .rodata .rodata*))
        KEEP(*clock.o (.text .text* .rodata .rodata*))
        KEEP(*kservice.o (.text .text* .rodata .rodata*))
        KEEP(*scheduler.o (.text .text* .rodata .rodata*))
        KEEP(*trap*.o (.text .text* .rodata .rodata*))
        KEEP(*idle.o (.text .text* .rodata .rodata*))
        KEEP(*ipc.o (.text .text* .rodata .rodata*))
        KEEP(*thread.o (.text .text* .rodata .rodata*))
        KEEP(*object.o (.text .text* .rodata .rodata*))
        KEEP(*timer.o (.text .text* .rodata .rodata*))
        KEEP(*mem.o (.text .text* .rodata .rodata*))
        KEEP(*mempool.o (.text .text* .rodata .rodata*))
        /* RT-Thread Core End */

        . = ALIGN(8);
        __ramfunc_end__ = .;
    } > ILM

    .text (__vector_load_addr__ + __vector_ram_end__ - __vector_ram_start__) : {
        . = ALIGN(8);
        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)
        *(.srodata)
        *(.srodata*)

        *(.hash)
        *(.dyn*)
        *(.gnu*)
        *(.pl*)

        KEEP(*(.eh_frame))
        *(.eh_frame*)

        KEEP (*(.init))
        KEEP (*(.fini))
        . = ALIGN(8);

        /*********************************************
         *
         *      RT-Thread related sections - Start
         *
        *********************************************/
        /* section information for finsh shell */
        . = ALIGN(4);
        __fsymtab_start = .;
        KEEP(*(FSymTab))
        __fsymtab_end = .;
        . = ALIGN(4);
        __vsymtab_start = .;
        KEEP(*(VSymTab))
        __vsymtab_end = .;
        . = ALIGN(4);

        . = ALIGN(4);
        __rt_init_start = .;
        KEEP(*(SORT(.rti_fn*)))
        __rt_init_end = .;
        . = ALIGN(4);

        /* section information for modules */
        . = ALIGN(4);
        __rtmsymtab_start = .;
        KEEP(*(RTMSymTab))
        __rtmsymtab_end = .;

        /* RT-Thread related sections - end */

        /* section information for usbh class */
        . = ALIGN(8);
        __usbh_class_info_start__ = .;
        KEEP(*(.usbh_class_info))
        __usbh_class_info_end__ = .;

    } > XPI0

    .rel : {
        KEEP(*(.rel*))
    } > XPI0

    PROVIDE (__etext = .);
    PROVIDE (_etext = .);
    PROVIDE (etext = .);

    .fast_ram (NOLOAD) : {
        KEEP(*(.fast_ram))
    } > ILM

    .bss(NOLOAD) : {
        . = ALIGN(8);
        __bss_start__ = .;
        *(.bss)
        *(.bss*)
        *(.sbss*)
        *(.scommon)
        *(.scommon*)
        *(.dynsbss*)
        *(COMMON)
        . = ALIGN(8);
        _end = .;
        __bss_end__ = .;
    } > DLM

    /* Note: the .tbss and .tdata section should be adjacent */
    .tbss(NOLOAD) : {
        . = ALIGN(8);
        __tbss_start__ = .;
        *(.tbss*)
        *(.tcommon*)
        _end = .;
        __tbss_end__ = .;
    } > DLM

    .tdata : AT(etext) {
        . = ALIGN(8);
        __tdata_start__ = .;
        __thread_pointer = .;
        *(.tdata)
        *(.tdata*)
        . = ALIGN(8);
        __tdata_end__ = .;
    } > DLM

    .data : AT(etext + __tdata_end__ - __tdata_start__) {
        . = ALIGN(8);
        __data_start__ = .;
        __global_pointer$ = . + 0x800;
        *(.data)
        *(.data*)
        *(.sdata)
        *(.sdata*)

        KEEP(*(.jcr))
        KEEP(*(.dynamic))
        KEEP(*(.got*))
        KEEP(*(.got))
        KEEP(*(.gcc_except_table))
        KEEP(*(.gcc_except_table.*))

        . = ALIGN(8);
        PROVIDE(__preinit_array_start = .);
        KEEP(*(.preinit_array))
        PROVIDE(__preinit_array_end = .);

        . = ALIGN(8);
        PROVIDE(__init_array_start = .);
        KEEP(*(SORT_BY_INIT_PRIORITY(.init_array.*)))
        KEEP(*(.init_array))
        PROVIDE(__init_array_end = .);

        . = ALIGN(8);
        PROVIDE(__fini_array_start = .);
        KEEP(*(SORT_BY_INIT_PRIORITY(.fini_array.*)))
        KEEP(*(.fini_array))
        PROVIDE(__fini_array_end = .);

        . = ALIGN(8);
        PROVIDE(__ctors_start__ = .);
        KEEP(*crtbegin*.o(.ctors))
        KEEP(*(EXCLUDE_FILE (*crtend*.o) .ctors))
        KEEP(*(SORT(.ctors.*)))
        KEEP(*(.ctors))
        PROVIDE(__ctors_end__ = .);

        . = ALIGN(8);
        KEEP(*crtbegin*.o(.dtors))
        KEEP(*(EXCLUDE_FILE (*crtend*.o) .dtors))
        KEEP(*(SORT(.dtors.*)))
        KEEP(*(.dtors))
        . = ALIGN(8);
        __data_end__ = .;
        PROVIDE (__edata = .);
        PROVIDE (_edata = .);
        PROVIDE (edata = .);
    } > DLM
    __fw_size__ = __data_end__ - __tdata_start__ + etext - __app_load_addr__;

    .heap(NOLOAD) : {
        . = ALIGN(8);
        __heap_start__ = .;
        . += HEAP_SIZE;
        __heap_end__ = .;
    } > AXI_SRAM


    .stack(NOLOAD) : {
        . = ALIGN(8);
        __stack_base__ = .;
        . += STACK_SIZE;
        . = ALIGN(8);
        PROVIDE (_stack = .);
        PROVIDE (_stack_in_dlm = .);
        PROVIDE( __rt_rvstack = . );
    } > DLM

    .noncacheable.init : AT(etext + __data_end__ - __tdata_start__ + __ramfunc_end__ - __ramfunc_start__) {
        . = ALIGN(8);
        __noncacheable_init_start__ = .;
        KEEP(*(.noncacheable.init))
        __noncacheable_init_end__ = .;
        . = ALIGN(8);
    } > NONCACHEABLE_RAM

    .noncacheable.bss (NOLOAD) : {
        . = ALIGN(8);
        KEEP(*(.noncacheable))
        KEEP(*(.noncacheable.non_init))
        KEEP(*(.noncacheable.non_init.*))
        __noncacheable_bss_start__ = .;
        KEEP(*(.noncacheable.bss))
        KEEP(*(.noncacheable.bss.*))
        __noncacheable_bss_end__ = .;
        . = ALIGN(8);
    } > NONCACHEABLE_RAM

    .ahb_sram (NOLOAD) : {
        KEEP(*(.ahb_sram))
    } > AHB_SRAM

    __noncacheable_start__ = ORIGIN(NONCACHEABLE_RAM);
    __noncacheable_end__ = ORIGIN(NONCACHEABLE_RAM) + LENGTH(NONCACHEABLE_RAM);
    __share_mem_start__ = ORIGIN(SHARE_RAM);
    __share_mem_end__ = ORIGIN(SHARE_RAM) + LENGTH(SHARE_RAM);

}
