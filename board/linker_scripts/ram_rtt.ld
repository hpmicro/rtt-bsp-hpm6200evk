/*
 * Copyright 2021-2025 HPMicro
 * SPDX-License-Identifier: BSD-3-Clause
 */

ENTRY(_start)

STACK_SIZE = DEFINED(_stack_size) ? _stack_size : 0x2000;
HEAP_SIZE = DEFINED(_heap_size) ? _heap_size : 0x8000;
NONCACHEABLE_SIZE = DEFINED(_noncacheable_size) ? _noncacheable_size : 0x10000;

MEMORY
{
    ILM (wx) : ORIGIN = 0x00000000, LENGTH = 128K
    DLM (w) : ORIGIN = 0x00080000, LENGTH = 128K
    NONCACHEABLE_RAM (wx) : ORIGIN = 0x01080000, LENGTH = NONCACHEABLE_SIZE
    AXI_SRAM  (wx) : ORIGIN = 0x01090000, LENGTH = 224K
    SHARE_RAM (w) : ORIGIN = 0x010BC000, LENGTH = 16K
    AHB_SRAM (w) : ORIGIN = 0xF0300000, LENGTH = 32k
}

SECTIONS
{
    .start : {
        . = ALIGN(8);
        KEEP(*(.start))
    } > ILM

    .vectors : {
        . = ALIGN(8);
        KEEP(*(.isr_vector))
        KEEP(*(.vector_table))
        . = ALIGN(8);
    } > ILM

    .text : {
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
        *(FalPartTable)

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

        PROVIDE (__etext = .);
        PROVIDE (_etext = .);
        PROVIDE (etext = .);
    } > ILM

    .rel : {
        KEEP(*(.rel*))
    } > ILM

    .fast_ram (NOLOAD) : {
        KEEP(*(.fast_ram))
    } > DLM

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

    /* Note: .tbss and .tdata should be adjacent */
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

    .fast : AT(etext + __data_end__ - __tdata_start__) {
        . = ALIGN(8);
        PROVIDE(__ramfunc_start__ = .);
        *(.fast)
        . = ALIGN(8);
        PROVIDE(__ramfunc_end__ = .);
    } > ILM

    .noncacheable.init : AT(etext + __data_end__ - __tdata_start__ + __ramfunc_end__ - __ramfunc_start__) {
        . = ALIGN(8);
        __noncacheable_init_start__ = .;
        KEEP(*(.noncacheable.init))
        __noncacheable_init_end__ = .;
        . = ALIGN(8);
    } > NONCACHEABLE_RAM

    .sh_mem (NOLOAD) : {
        KEEP(*(.sh_mem))
    } > SHARE_RAM
    __share_mem_start__ = ORIGIN(SHARE_RAM);
    __share_mem_end__ = ORIGIN(SHARE_RAM) + LENGTH(SHARE_RAM);

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

    __noncacheable_start__ = ORIGIN(NONCACHEABLE_RAM);
    __noncacheable_end__ = ORIGIN(NONCACHEABLE_RAM) + LENGTH(NONCACHEABLE_RAM);

     .ahb_sram (NOLOAD) : {
        KEEP(*(.ahb_sram))
    } > AHB_SRAM

    .stack(NOLOAD) : {
        . = ALIGN(8);
        __stack_base__ = .;
        . += STACK_SIZE;
        PROVIDE (_stack = .);
        PROVIDE (_stack_in_dlm = .);
        PROVIDE (__rt_rvstack = .);
    } > DLM

    .heap (NOLOAD) : {
        . = ALIGN(8);
        __heap_start__ = .;
        . += HEAP_SIZE;
        __heap_end__ = .;

    } > DLM
}
