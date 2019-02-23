# SmartDisplay using BananaPI M2 Zero and 3.5 inch HDMI IPS LCD

1. Download 2018-07-07-raspbian-jessie-preview-bpi-m2z-sd-emmcfrom

`https://dev.banana-pi.org.cn/Image/BPI-M2Z/Raspbian/2018-07-07-raspbian-jessie-preview-bpi-m2z-sd-emmc.img.zip

2. Flash using Etcher or Rufus

3. Enable Wi-Fi in terminal:

sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

#ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
#update_config=1
network={
ssid="***"
psk="****"
priority=1
}

replace *** to ssid and password


4. Login to SSH as pi/bananapi and change user to root

su -

5. Update system 

apt update
apt upgrade

6. NodeJS

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

7. Add user smartdisplay

adduser smartdisplay

8. Login via SSH as smartdisplay

9. Install MagicMirror

git clone https://github.com/MichMich/MagicMirror

cd MagicMirror
npm install

cp config/config.js.sample config/config.js

10. Autostart MagicMirror

nano /home/smartdisplay/mm.sh

add
cd ~/MagicMirror
DISPLAY=:0 npm start

chmod +x /home/smartdisplay/mm.sh

11. Change autologin user

sudo nano /etc/lightdm/lightdm.conf

replace 

autologin-user=pi

to 

autologin-user=smartdisplay

and 

#autologin-user-timeout=0

to 

autologin-user-timeout=0

then

sudo dpkg-reconfigure lightdm 


12. Add MagicMirror to autostart

sudo nano /home/smartdisplay/.config/lxsession/LXDE-pi/autostart

replace

@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash
@point-rpi

to 

/home/smartdisplay/mm.sh

13. Hide mouse cursor

sudo apt-get install unclutter

sudo nano /home/smartdisplay/.config/lxsession/LXDE-pi/autostart

add at top

@unclutter -display :0 -idle 3 -root -noevents

 
