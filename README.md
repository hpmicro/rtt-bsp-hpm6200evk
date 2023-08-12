# rtt-bsp-hpm6200evk

RT-Thread Studio BSP for HPM6200EVK Board

## Supported examples

***

- blink_led
- uart_dma_demo
- timer_demo
- flashdb_demo
- mcan_example
- adc_example
- usb_device_generic_hid
- usb_host_msc_udisk

## Environment Setup

### Toolchain setup

- After installing the BSP package, users need to set the `RTT_RISCV_TOOLCHAIN` environment variable before creating any examples/projects
    - Assuming that the toolchain is installed in `C:\DevTools\RT-ThreadStudio\repo\Extract\ToolChain_Support_Packages\RISC-V\RISC-V-GCC-RV32\2022-04-12\bin`, User can set the `RTT_RISCV_TOOLCHAIN` environment variable referring below figure:

![Set RTT_RISCV_TOOLCHAIN environment variable](documents/images/set_rtt_riscv_toolchain_env.png)