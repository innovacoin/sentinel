#!/bin/bash
COIN='https://github.com/innovacoin/innova/releases/download/12.1.10/linux_x64.tar.gz'

innova-cli stop
rm -rf /usr/bin/innova*
rm -rf /usr/bin/loca/innova*
cd /root/innova
./innova-cli stop
rm -rf /root/innova/innova*
wget $COIN
tar xvzf linux_x64.tar.gz
cp innova* /usr/local/bin
cd /root/innova
./innovad -daemon
sleep 10
innova-cli getinfo
echo "Job completed successfully"
