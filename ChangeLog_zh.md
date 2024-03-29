# 更新

## v1.4.1
- 修复：
  - I2C开启DMA后传输出错的问题
  - 默认模板工程创建出错的问题

## v1.4.0
- 整合了 hpm_sdk v1.4.0
- 升级RT-Thread 到 v5.0.2
- 更新：
  - 增强了 SPI 驱动
  - 增强了 I2C 驱动
  - 增加了对 `rt_pin_get` API的支持
  - RTC驱动中默认使能电池域掉电保持
- 修复：
  - 修复了`pwm`驱动返回值类型不匹配的问题

## v1.3.0
- 整合了hpm_sdk v1.3.0
  - 注：
    - SDK根目录下的docs,middleware,samples, scripts等目录被移除
- 更新
  - 增加了SVD文件的支持
  - CAN: 增加了硬件过滤器支持
  - 默认禁用了PWM输出反向
- 修复：
  - RT-Thread Studio生成的elf文件无法被`Ozone`正确的识别
  - 在线包`i2c tools`不工作
  - 当开启`ADC12`后编译失败
  - GPIO在配置为开漏极并上拉模式后无法正确的读出引脚的电平

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