# USB网卡

## 概述

本示例工程展示USB作为主机驱动USB网卡，目前支持RTL8152和ASIX8872B两款USB网卡

- USB主机枚举成功USB网卡后，会自动对接rtthread lwip，可使用rtthread的SAL接口。

## 硬件设置

- 使用USB Type-C线缆连接PC USB端口和PWR DEBUG端口
- 使用USB Type-C转USB-A线缆连接USB网卡，有些USB网卡是Type-C接口，可以不需要Type-C转USB-A线缆。

## 运行示例

当工程正确运行后

* 编译下载程序, 并插入USB网卡
* 串口终端显示枚举成功，打印USB网卡相关信息

- 以下是RTL8152 USB网卡信息

```console
 \ | /
- RT -     Thread Operating System
 / | \     5.0.2 build Jun 26 2024 14:22:06
 2006 - 2022 Copyright by RT-Thread team
lwIP-2.1.2 initialized!
[I/sal.skt] Socket Abstraction Layer initialize success.
[I/USB] EHCI HCIVERSION:0x0100
[I/USB] EHCI HCSPARAMS:0x010011
[I/USB] EHCI HCCPARAMS:0x0006
[I/USB] EHCI ppc:1, n_ports:1, n_cc:0, n_pcc:0
msh />[I/USB] EHCI uses tt for ls/fs device
[I/usbh_hub] New high-speed device on Bus 0, Hub 1, Port 1 connected
[I/usbh_core] New device found,idVendor:0bda,idProduct:8152,bcdDevice:2000
[I/usbh_core] The device has 2 bNumConfigurations
[I/usbh_core] The device has 1 interfaces
[I/usbh_core] Enumeration success, start loading class driver
[I/usbh_core] Loading rtl8152 class driver
[I/rtl8152] rtl8152 version 0x0002
[I/rtl8152] RTL8152 MAC address 00:e0:4c:36:02:8f
[I/rtl8152] Ep=81 Attr=02 Mps=512 Interval=00 Mult=00
[I/rtl8152] Ep=02 Attr=02 Mps=512 Interval=00 Mult=00
[I/rtl8152] Ep=83 Attr=03 Mps=2 Interval=08 Mult=00
[I/rtl8152] Register RTL8152 Class:/dev/rtl8152
[I/rtl8152] Create rtl8152 rx thread

```

- 以下是AX88772B USB网卡信息

```console

 \ | /
- RT -     Thread Operating System
 / | \     5.0.2 build Jun 26 2024 14:22:06
 2006 - 2022 Copyright by RT-Thread team
lwIP-2.1.2 initialized!
[I/sal.skt] Socket Abstraction Layer initialize success.
[I/USB] EHCI HCIVERSION:0x0100
[I/USB] EHCI HCSPARAMS:0x010011
[I/USB] EHCI HCCPARAMS:0x0006
[I/USB] EHCI ppc:1, n_ports:1, n_cc:0, n_pcc:0
msh />[I/USB] EHCI uses tt for ls/fs device
[I/usbh_hub] New high-speed device on Bus 0, Hub 1, Port 1 connected
[I/usbh_core] New device found,idVendor:0b95,idProduct:772b,bcdDevice:0001
[I/usbh_core] The device has 1 bNumConfigurations
[I/usbh_core] The device has 1 interfaces
[I/usbh_core] Enumeration success, start loading class driver
[I/usbh_core] Loading asix class driver
[I/asix] asix MAC address 00:6f:00:01:01:3c
[I/asix] internal PHY address 0x10
[I/asix] asix chipcode 0x20
[I/asix] RX_CTL is 0x0088 after all initializations
[I/asix] Medium Status is 0x0306 after all initializations
[I/asix] Ep=81 Attr=03 Mps=8 Interval=11 Mult=00
[I/asix] Ep=82 Attr=02 Mps=512 Interval=00 Mult=00
[I/asix] Ep=03 Attr=02 Mps=512 Interval=00 Mult=00
[I/asix] Init ASIX AX88772B done
[I/asix] Register ASIX Class:/dev/asix
[I/asix] Create asix rx thread

```

- 等待网络初始化完毕，默认使能DHCP,敲击ifconfig，查看是否自动分配IP，如出现以下说明网络初始化成功

```console

msh />ifconfig
network interface device: u3 (Default)
MTU: 1500
MAC: 00 6f 00 01 01 3c
FLAGS: UP LINK_UP INTERNET_UP DHCP_ENABLE ETHARP BROADCAST IGMP
ip address: 192.168.1.117
gw address: 192.168.1.1
net mask  : 255.255.255.0
dns server #0: 202.96.128.86
dns server #1: 192.168.1.1

```
- 进行ping操作，说明网络正常
```console

msh />ping www.baidu.com
ping: not found specified netif, using default netdev u3.
60 bytes from 183.2.172.42 icmp_seq=0 ttl=52 time=9 ms
60 bytes from 183.2.172.42 icmp_seq=1 ttl=52 time=12 ms
60 bytes from 183.2.172.42 icmp_seq=2 ttl=52 time=9 ms
60 bytes from 183.2.172.42 icmp_seq=3 ttl=52 time=11 ms

```

- 进行iperf测试

* "iperf -c 主机ip -p 5001",测试iperf client，发送性能。

```console

msh />iperf -c 192.168.1.103 -p 5001
msh />[I/iperf] Connect to iperf server successful!
[I/iperf] iperfc01: 44.7670 Mbps!
[I/iperf] iperfc01: 45.5210 Mbps!
[I/iperf] iperfc01: 44.1450 Mbps!
[I/iperf] iperfc01: 44.3020 Mbps!
[I/iperf] iperfc01: 43.2660 Mbps!
[I/iperf] iperfc01: 44.0860 Mbps!
[I/iperf] iperfc01: 45.0290 Mbps!

```

* "iperf -s -p 5001",测试iperf server，接收性能。

```console

msh />iperf -s -p 5001
msh />[I/iperf] new client connected from (192.168.1.103, 51850)
[I/iperf] iperfd01: 61.9920 Mbps!
[I/iperf] iperfd01: 63.3440 Mbps!

```


## 支持的命令

```console

RT-Thread shell commands:
reset            - reset the board
lsusb            - ls usb devices
usbh_deinit      - deinit usb host
usbh_init        - init usb host
iperf            - the network bandwidth measurement tool
list             - list objects
version          - show RT-Thread version information
clear            - clear the terminal screen
free             - Show the memory usage in the system.
ps               - List threads in the system.
help             - RT-Thread shell help.
tail             - print the last N - lines data of the given file
echo             - echo string to file
df               - disk free
umount           - Unmount the mountpoint
mount            - mount <device> <mountpoint> <fstype>
mkfs             - format disk with file system
mkdir            - Create the DIRECTORY.
pwd              - Print the name of the current working directory.
cd               - Change the shell working directory.
rm               - Remove(unlink) the FILE(s).
cat              - Concatenate FILE(s)
mv               - Rename SOURCE to DEST.
cp               - Copy SOURCE to DEST.
ls               - List information about the FILEs.
netstat          - list the information of TCP / IP
dns              - list and set the information of dns
ping             - ping network host
ifconfig         - list the information of all network interfaces
pin              - pin [option]
date             - get date and time or set (local timezone) [year month day hour min sec]

```

