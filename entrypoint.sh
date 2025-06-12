#!/bin/sh

# Запуск Shadowsocks
ssserver --config config.json

# Запуск gotty на порту 7681
gotty -w --port 7681 bash &

# Поддержка фоновых процессов
wait
