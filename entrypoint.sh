#!/bin/sh

# Запуск shadowsocks-libev
ss-server -s 0.0.0.0 -p 8388 -k mypassword -m aes-256-gcm --fast-open &

# Запуск gotty на порту 7681
gotty -w --port 7681 bash &

# Ожидание фоновых процессов
wait
