# Change Log

## v1.2.0
- Integrated hpm_sdk v1.2.0
  - Note:
    - the docs, middleware, scripts, samples folder in SDK root directory were removed
- Updated:
    - Upgraded rt-thread to v5.0.1
    - Added `README.md` for all samples
    - Added UART RXFIFO timeout interrupt support
    - Added `flash_release` build and `ram_release` build
  - Fixed:
    - Uart lost data when working in low baudrate

## v1.1.0
- Integrated the SDK v1.1.0 release
  - Note:
    - The doc, middleware, cmake, samples foler were removed
  - Updated:
    - Added MCAN driver
  - Added examples:
    - adc_example
    - blink_led
    - flashdb_demo
    - mcan_example
    - timer_demo
    - uart_dma_demo
    - usb_device_generic_hid
    - usb_host_msc_udisk
