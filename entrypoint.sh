#!/bin/sh

# Старт shellinabox
shellinaboxd -b -p ${PORT} &

# Старт Shadowsocks WS
ssserver -c /etc/shadowsocks/config.json -u &

# Очистка tc и iptables
tc qdisc del dev eth0 root 2>/dev/null
iptables -t mangle -F

# Настройка HTB
tc qdisc add dev eth0 root handle 1: htb default 20
tc class add dev eth0 parent 1: classid 1:10 htb rate 100mbit ceil 100mbit prio 1  # VPN
tc class add dev eth0 parent 1: classid 1:20 htb rate 512kbit ceil 1mbit prio 5    # System

# Маркировка VPN трафика
iptables -t mangle -A OUTPUT -p tcp --sport 8388 -j MARK --set-mark 10
iptables -t mangle -A OUTPUT -p udp --sport 8388 -j MARK --set-mark 10

# Привязка к классам
tc filter add dev eth0 parent 1:0 protocol ip handle 10 fw flowid 1:10

wait
