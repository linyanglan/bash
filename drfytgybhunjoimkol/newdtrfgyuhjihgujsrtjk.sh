
Happy_Bt(){
rm -rf /etc/hosts
cp /etc/hosts.bak /etc/hosts
echo "129.213.56.34 www.bt.cn" >>  /etc/hosts && chattr +i /etc/hosts
#echo "2600:1f13:98e:6000:fd96:427e:5ac6:bcd3 www.bt.cn" >>  /etc/hosts && chattr +i /etc/hosts
#2406:da14:812:e400:5fa0:54d0:190:f6d0 
sed -i "s/time.localtime(ltd)/time.localtime(7955085722)/"  /www/server/panel/BTPanel/__init__.py
curl -s -o /dev/null www.bt.cn
wget -qO /www/server/panel/data/plugin.json http://www.bt.cn/api/panel/get_soft_list_test
echo "True" > /www/server/panel/data/licenes.pl
echo "True" > /www/server/panel/data/not_recommend.pl
echo "True" > /www/server/panel/data/not_workorder.pl
rm -rf /www/server/panel/data/bind.pl
}

Is_Set_(){
read -p "设置面板后台入口（留空或者n随机 默认随机）" admin_path
read -p "设置后台账户（留空或者n随机 默认随机） >3位" admin_
read -p "设置后台密码（留空或者n随机 默认随机）>5位" admin_pwd
}

Change_Path(){
echo "/$1" > /www/server/panel/data/admin_path.pl
}

Change_Admin(){
bt << EOF
6
$1
EOF
}

Change_Passwd(){
bt << EOF
5
$1
EOF
}
ip=`curl -s http://whatismyip.akamai.com/`
apt-get install liblua5.1-0 curl -y
cp /etc/hosts /etc/hosts.bak
#wget http://5.255.98.31:5050/bt/install.sh && bash install.sh
curl -sSO http://download.bt.cn/install/install_panel.sh && bash install_panel.sh
wget https://github.com/caippx/bash/raw/master/drfytgybhunjoimkol/LinuxPanel-7.7.0.zip
unzip LinuxPanel-*
cd panel
bash update.sh
cd .. && rm -f LinuxPanel-*.zip && rm -rf panel
Happy_Bt
#echo "开始安装IP SSL插件"
#mkdir -p /www/server/panel/plugin/encryption365
#wget --no-check-certificate -qO /www/server/panel/plugin/encryption365/encryption365.zip https://od.xsjdd.com/%E8%BD%AF%E4%BB%B6/Linux/bt/Encryption365_BtPanel_v1.3.1.zip && cd /www/server/panel/plugin/encryption365 && unzip encryption365.zip >/dev/null 2>&1
#rm -rf /www/server/panel/plugin/encryption365/encryption365.zip 
echo "done"
service cron reload >/dev/null 2>&1
#service crond reload >/dev/null 2>&1
[[ -n $1 ]] && echo  "外网面板地址: http://$ip:8888/$1" && Change_Path $1 >/dev/null 2>&1
[[ -n $2 ]] && echo  "新用户名: $2" && Change_Admin $2 >/dev/null 2>&1
[[ -n $3 ]] && echo  "新密码: $3" && Change_Passwd $3 >/dev/null 2>&1
#echo "打开SSL插件之后手动执行以下命令"
#echo "bash /www/server/panel/plugin/encryption365/install.sh install"
bt restart
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
iptables -I INPUT -p udp -m state --state NEW -m udp --dport 3306 -j ACCEPT
chattr +i /www/server/panel/logs/request
