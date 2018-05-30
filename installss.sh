#!/bin/sh
echo install shadowsocks
yum -y install epel-release
yum -y install python-pip
pip install --upgrade pip
yum clean all
pip install shadowsocks
echo {>/etc/shadowsocks.json
echo \"server\": \"0.0.0.0\",>>/etc/shadowsocks.json
echo \"port_password\": {>>/etc/shadowsocks.json
echo \"11951\": \"mightyang1985\",>>/etc/shadowsocks.json
echo \"11952\": \"mightyang1985\">>/etc/shadowsocks.json
echo },>>/etc/shadowsocks.json
echo \"local_address\": \"127.0.0.1\",>>/etc/shadowsocks.json
echo \"local_port\": 1080,>>/etc/shadowsocks.json
echo \"timeout\": 300,>>/etc/shadowsocks.json
echo \"method\": \"aes-256-cfb\">>/etc/shadowsocks.json
echo }>>/etc/shadowsocks.json

echo write shadowsocks.service

echo [Unit]>/etc/systemd/system/shadowsocks.service
echo Description=Shadowsocks>>/etc/systemd/system/shadowsocks.service
echo [Service]>>/etc/systemd/system/shadowsocks.service
echo TimeoutStartSec=0>>/etc/systemd/system/shadowsocks.service
echo ExecStart=/usr/bin/ssserver -c /etc/shadowsocks.json>>/etc/systemd/system/shadowsocks.service
echo [Install]>>/etc/systemd/system/shadowsocks.service
echo WantedBy=multi-user.target>>/etc/systemd/system/shadowsocks.service

echo enable and start shadowsocks
systemctl enable shadowsocks
systemctl start shadowsocks

echo setup iptables
yum -y install iptables iptables-services
systemctl stop iptables
systemctl start iptables
iptables -F
iptables -X
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 11951 -j ACCEPT
iptables -A INPUT -p tcp --dport 11952 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
service iptables save
systemctl restart iptables
