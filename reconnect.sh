#!/bin/bash
pkg update -y && echo "y" | termux-setup-storage && pkg install python tsu libexpat openssl lua53 imagemagick chafa -y && pip install requests psutil aiohttp wand crypto
curl -L -o /sdcard/download/reconnect.lua https://raw.githubusercontent.com/nullus7/reconnect/refs/heads/main/reconnect.lua
