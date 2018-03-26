#!/bin/bash
sudo touch /var/swap.img
sudo chmod 600 /var/swap.img
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
mkswap /var/swap.img
sudo swapon /var/swap.img
sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install nano htop git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common -y
sudo apt-get install libboost-all-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
mkdir /root/temp
sudo git clone https://github.com/innovacoin/innova /root/temp
chmod -R 755 /root/temp
cd /root/temp
./autogen.sh
./configure
sudo make
sudo make install
cd
mkdir /root/innova
mkdir /root/.innovacore
cp /root/temp/src/innovad /root/innova
cp /root/temp/src/innova-cli /root/innova
chmod -R 755 /root/innova
chmod -R 755 /root/.innovacore
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
echo "Masternode private key: $masternodekey"
echo "Job completed successfully"