#!/bin/bash

# 定义默认值
DEFAULT_INTERFACE="eth0"
DEFAULT_IP="192.168.0.1"
DEFAULT_PORT="5762"
DEFAULT_DELAY="300ms"
DEFAULT_LOSS="5%"

# 实际使用值
INTERFACE=$DEFAULT_INTERFACE
IP=$DEFAULT_IP
PORT=$DEFAULT_PORT
DELAY=$DEFAULT_DELAY
LOSS=$DEFAULT_LOSS

# 打印帮助信息
print_help() {
    echo "$(basename "$0") [-h] [-i INTERFACE] [-a TARGET_IP] [-p TARGET_PORT] [-d DELAY] [-l LOSS] [-r] [-s]"
    echo "       -h                  show help"
    echo "       -i INTERFACE        interface (device), default $DEFAULT_INTERFACE"
    echo "       -a TARGET_IP        target ip, default $DEFAULT_IP"
    echo "       -p TARGET_PORT      target port，default $DEFAULT_PORT"
    echo "       -d DELAY            network delay，second:s millisecond:ms microsecond:us or unitless digit，default $DEFAULT_DELAY"
    echo "       -l LOSS             loss packets rate，default $DEFAULT_LOSS"
    echo "       -r                  remove all rule"
    echo "       -s                  show all rule"
    exit 0
}

# 打印规则
print_rules() {
    echo "qdisc："
    tc qdisc show dev "$INTERFACE"
    echo "filter："
    tc filter show dev "$INTERFACE"
    exit 0
}

# 移除规则
remove_rules() {
    sudo tc qdisc del dev "$INTERFACE" root
    exit 0
}

while getopts "i:a:p:d:l:rhs" opt; do
    case $opt in
        i) INTERFACE="$OPTARG" ;;
        a) IP="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
        d) DELAY="$OPTARG" ;;
        l) LOSS="$OPTARG" ;;
        r) remove_rules ;;
        s) print_rules ;;
        h) print_help ;;
        *) print_help ;;
    esac
done


sudo tc qdisc add dev "$INTERFACE" root handle 1: prio
# 这个命令会创建3个默认的class  1:1 1:2 1:3 PRIO 另一种意义的pfifo_fast 基于优先级的有类队列规则
sudo tc filter add dev "$INTERFACE" protocol ip  parent 1: prio 1 u32 match ip dst "$IP" match ip dport "$PORT" 0xffff flowid 1:1
sudo tc filter add dev "$INTERFACE" protocol all parent 1: prio 2 u32 match ip dst 0.0.0.0/0 flowid 1:2
sudo tc filter add dev "$INTERFACE" protocol all parent 1: prio 2 u32 match ip protocol 1 0xff flowid 1:2
# 将指定的ip和端口数据发送给 1:1 , 将其他流量指向1:2
sudo tc qdisc add dev "$INTERFACE" parent 1:2 handle 20: sfq
sudo tc qdisc add dev "$INTERFACE" parent 1:1 handle 10: netem delay "$DELAY" loss "$LOSS"
# 创建1:1队列，同时设置延迟和丢包率,创建1:2队列接受默认流量
