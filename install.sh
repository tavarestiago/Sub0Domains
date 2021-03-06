#!/bin/bash

LOCALPATH=$(pwd)

#COLORS
#========================================
#https://www.shellhacks.com/bash-colors/
RED='\e[31m'
GREEN='\e[32m'
CYAN='\e[36m'
PURPLE='\e[35m'
YELLOW='\e[33m'
NC='\e[0m' # No Color
#========================================

if [[ $(id -u) != 0 ]]; then
    echo -e "\n[!] Install.sh need to run as root or sudoer"
    exit 0
fi


if [[ ! -d $LOCALPATH/tools ]]; then
    mkdir $LOCALPATH/tools
fi

if [[ ! -d $LOCALPATH/subdomains ]]; then
    mkdir $LOCALPATH/subdomains
fi

if [[ ! -e $LOCALPATH/targets.txt ]]; then
    touch $LOCALPATH/targets.txt
    echo "tesla.com" >> targets.txt
    echo "microsoft.com" >> targets.txt
fi

#if [[ ! -e $LOCALPATH/api.config ]]; then
#    touch $LOCALPATH/api.config
#    echo "censys=" >> api.config
#    echo "shodan=" >> api.config
#fi

echo -e "${RED}[+] Installing all requirements${NC}"
sudo apt-get update && sudo apt-get install golang gzip zip git python3-pip -y

echo -e "${RED}[+] Configuring Sublist3r${NC}"
cd $LOCALPATH/tools
git clone https://github.com/aboul3la/Sublist3r
cd Sublist3r
sudo pip3 install -r requirements.txt

echo -e "${RED}[+] Configuring subscraper${NC}"
cd $LOCALPATH/tools
git clone https://github.com/m8r0wn/subscraper
cd subscraper
sudo python3 setup.py install

echo -e "${RED}[+] Configuring assetfinder${NC}"
mkdir -p $LOCALPATH/tools/assetfinder
cd $LOCALPATH/tools/assetfinder
wget https://github.com/tomnomnom/assetfinder/releases/download/v0.1.1/assetfinder-linux-amd64-0.1.1.tgz
wait
gunzip -c assetfinder-linux-amd64-0.1.1.tgz |tar xvf -
chmod +x assetfinder

echo -e "${RED}[+] Setting permissions back to $SUDO_USER ${NC}"
cd $LOCALPATH/
chown -R $SUDO_USER.$SUDO_USER * 


echo -e "${GREEN}[+] DONE${NC}"