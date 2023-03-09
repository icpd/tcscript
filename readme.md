Implementing a bad network using "tc-netem" and "tc-filter"

## Usage
```bash
$ ./tc.sh
tc.sh [-h] [-i INTERFACE] [-a TARGET_IP] [-p TARGET_PORT] [-d DELAY] [-l LOSS] [-r] [-s]
       -h                  显示帮助信息
       -i INTERFACE        指定网卡接口，默认为 eth0
       -a TARGET_IP        指定目标IP地址，默认为 192.168.0.1
       -p TARGET_PORT      指定目标端口号，默认为 5762
       -d DELAY            指定网络延迟，秒s 毫秒ms 微秒us或者无单位数字，默认为 300ms
       -l LOSS             指定网络丢包率，默认为 5%
       -r                  移除所有规则
       -s                  显示所有规则
```
