#!/bin/bash

COIN='https://github.com/innovacoin/innova/releases/download/12.1.10/linux_x64.tar.gz'

sudo apt-get update -y
mkdir /root/innova
mkdir /root/.innovacore
cd /root/innova
wget -q $COIN
tar xvzf linux_x64.tar.gz
cp innova* /usr/local/bin
sudo apt-get install -y pwgen
GEN_PASS=`pwgen -1 20 -n`
echo -e "rpcuser=innovauser\nrpcpassword=${GEN_PASS}\nrpcport=14519\nport=14520\nlisten=1\nmaxconnections=256" > /root/.innovacore/innova.conf
cd /root/innova
./innovad -daemon
sleep 10
masternodekey=$(./innova-cli masternode genkey)
./innova-cli stop
echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.innovacore/innova.conf
./innovad -daemon
cd /root/.innovacore
sudo apt-get install -y git python-virtualenv
sudo git clone https://github.com/innovacoin/sentinel.git
cd sentinel
export LC_ALL=C
sudo apt-get install -y virtualenv
virtualenv venv
venv/bin/pip install -r requirements.txt
echo "innova_conf=/root/.innovacore/innova.conf" >> /root/.innovacore/sentinel/sentinel.conf
#get mnchecker
cd /root
sudo git clone https://github.com/innovacointeam/mnchecker /root/mnchecker
#setup cron
crontab -l > tempcron
echo "* * * * * cd /root/.innovacore/sentinel && ./venv/bin/python bin/sentinel.py 2>&1 >> sentinel-cron.log" > tempcron
echo "*/30 * * * * /root/mnchecker/mnchecker --currency-handle=\"innova\" --currency-bin-cli=\"innova-cli\" --currency-datadir=\"/root/.innovacore\" > /root/mnchecker/mnchecker-cron.log 2>&1" >> tempcron
crontab tempcron
rm tempcron
#set masternodeprivkey
clear
NODEIP=$(curl -s4 icanhazip.com)
echo "VPS ip: $NODEIP"
echo "Masternode private key: $masternodekey"
echo "Job completed successfully"
