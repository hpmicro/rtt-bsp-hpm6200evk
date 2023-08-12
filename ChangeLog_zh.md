# 更新

## v1.2.0
- 整合了hpm_sdk v1.2.0
  - 注：
    - SDK根目录下的docs,middleware,samples, scripts等目录被移除
- 更新
  - 迁移到rt-thread v5.0.1
  - 增加了sample README
  - 增加了 `flash_release` 和 `ram_release` 工程
  - 增加了 UART RXFIFO timeout 中断支持
- 修复：
  - uart 在低波特率下丢数据

## v1.1.0
- 整合了SDK v1.1.0
  - 注：
    - SDK根目录下的doc, middleware,samples,cmake目录被删除
- 更新：
  - 增加MCAN驱动
- 增加了如下示例:
  - adc_example
  - blink_led
  - flashdb_demo
  - mcan_example
  - timer_demo
  - uart_dma_demo
  - usb_device_generic_hid
  - usb_host_msc_udisk
