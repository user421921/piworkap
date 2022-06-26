#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
echo "-----Finished Updating!-----"
sudo apt-get install hostapd bridge-utils dnsmasq -y
echo "-----Installed Packages!-----"
echo "-----Stoping Hostapd and Dnsmasq...-----"
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq
echo "-----Stoped!-----"
echo "-------------------------------------------------"
echo "-----copy the following into the nano window-----:"
echo "interface wlan0"
echo "static ip_address=192.168.0.10/24"
echo "denyinterfaces eth0"
echo "denyinterfaces wlan0"
read -n1 -r -p "Press any key to continue..." key
sudo nano /etc/dhcpcd.conf
echo "-----Moving OG Dnsmasq to backup-----"
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
echo "-----Moved!-----"
echo "-----echoing extra lines to dnsmasq-----"
sudo echo "interface=wlan0" > /etc/dnsmasq.conf
sudo echo "dhcp-range=192.168.9.11,192.168.9.30,255.255.255.0,24h" >> /etc/dnsmasq.conf

############################sudo nano /etc/hostapd/hostapd.conf

echo -e "interface=wlan0 \nbridge=br0 \nhw_mode=g \nchannel=7 \nwmm_enabled=0 \nmacaddr_acl=0 \nauth_algs=1 \nignore_broadcast_ssid=0 \nwpa=2 \nwpa_key_mgmt=WPA-PSK \nwpa_pairwise=TKIP \nrsn_pairwise=CCMP \nssid=NETWORK \nwpa_passphrase=PASSWORD" >> /etc/hostapd/hostapd.conf

echo "find the #DAEMON_CONF='' and replace it with DAEMON_CONF='/etc/hostapd/hostapd.conf'"
read -n1 -r -p "Press any key to continue..." key
sudo nano /etc/default/hostapd

echo "find #net.ipv4.ip_forward=1 and uncomment the line"
read -n1 -r -p "Press any key to continue..." key
sudo nano /etc/sysctl.conf


sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
iptables-restore < /etc/iptables.ipv4.nat

sudo brctl addbr br0
sudo brctl addif br0 eth0
echo -e "auto br0 \niface br0 inet manual \nbridge_ports eth0 wlan0" >> sudo nano /etc/network/interfaces

read -n1 -r -p "Press any key to continue..." key
echo "time for reboot!"
sudo reboot
