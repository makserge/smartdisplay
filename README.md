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

adduser smartdisplay sudo

sudo nano /etc/sudoers

add 

smartdisplay    ALL=(ALL)       ALL

after

root    ALL=(ALL:ALL) ALL


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

14. Disable scrren off
 
sudo nano /home/smartdisplay/.config/lxsession/LXDE-pi/autostart
 
add at top
 
@xset s noblank
@xset s off
@xset -dpms

15. Expand root fs to SD size

sudo raspi-config --expand-rootfs

16. Install Python 3.6

sudo apt-get update -y
sudo apt-get install build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
wget https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz
tar xf Python-3.6.0.tar.xz
cd Python-3.6.0
./configure
make -j 4
sudo make altinstall
cd ..
sudo rm -r Python-3.6.0
rm Python-3.6.0.tar.xz
sudo apt-get --purge remove build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev -y
sudo apt-get autoremove -y
sudo apt-get clean

17. Remove Python 3.4

sudo apt remove python3
sudo apt-get autoremove

sudo ln -s /usr/local/bin/python3.6 /usr/bin/python3

18. Update Swig

sudo apt install libpcre3 libpcre3-dev

wget http://prdownloads.sourceforge.net/swig/swig-3.0.5.tar.gz
tar xvzf swig-3.0.5.tar.gz
cd swig-3.0.5
./configure --prefix=$HOME --with-perl5=/usr/bin/perl --with-python=/usr/local/bin/python3.6
make
make check
sudo make install
cd ..
rm -rf swig-3.0.5.tar.gz

19. Rhasspy setup

git clone https://github.com/synesthesiam/rhasspy.git

cd rhasspy/

nano create-venv.sh

replace

sudo apt-get install -y python3 python3-pip python3-venv python3-dev \
     build-essential autoconf libtool automake bison \
     sox espeak swig portaudio19-dev \
     libatlas-base-dev \
     sphinxbase-utils sphinxtrain pocketsphinx \
     jq checkinstall


to 

sudo apt-get install -y build-essential autoconf libtool automake bison \
     sox espeak swig portaudio19-dev \
     libatlas-base-dev \
     sphinxbase-utils sphinxtrain pocketsphinx \
     jq checkinstall


./create-venv.sh

 20. Rhasspy start
 
 /home/smartdisplay/rhasspy/run-venv.sh
 
 web interface will be available at http://localhost:12101
