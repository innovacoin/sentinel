#!/bin/bash
COIN='https://github.com/innovacoin/innova/releases/download/12.1.10/linux_x64.tar.gz'

innova-cli stop
rm -rf /usr/bin/innova*
rm -rf /usr/bin/local/innova*
cd /root/innova
./innova-cli stop
rm -rf /root/innova/inno*
rm -rf /root/innova/linux*
wget $COIN
tar xvzf linux_x64.tar.gz
cp innova* /usr/local/bin
cd /root/innova
./innovad -daemon -reindex
sleep 10
clear
innova-cli getinfo
echo "If you can see wallet version 120110, then the update is completed successfully"
