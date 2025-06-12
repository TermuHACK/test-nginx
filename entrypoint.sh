#!/bin/sh

# Пример запуска shadowsocks и gotty
ss-server -s 0.0.0.0 -p 8388 -k password -m aes-256-gcm &

gotty --port 8080 bash
