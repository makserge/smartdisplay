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

wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-armv7l.sh
sudo md5sum Miniconda3-latest-Linux-armv7l.sh # (optional) check md5
sudo /bin/bash Miniconda3-latest-Linux-armv7l.sh -> change default directory to /home/smartdisplay/miniconda3
sudo nano /home/smartdisplay/.bashrc # -> add: export PATH="/home/smartdisplay/miniconda3/bin:$PATH"
conda config --add channels rpi
sudo chown -R smartdisplay miniconda3

sudo reboot -h now
conda install python=3.6
sudo ln -s /home/smartdisplay/miniconda3/bin/python3.6-config /home/smartdisplay/miniconda3/bin/python-config
sudo ln -s /home/smartdisplay/miniconda3/bin/python3-config /usr/bin/python3-config


17. Update Swig

sudo apt install libpcre3 libpcre3-dev

wget http://prdownloads.sourceforge.net/swig/swig-3.0.10.tar.gz
tar xvzf swig-3.0.10.tar.gz
cd swig-3.0.10
./configure
make
sudo make install
cd ..
rm -rf swig-3.0.10.tar.gz

sudo rm -rf /usr/bin/swig

18. Rhasspy setup

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

19. Put Snowboy wake word to

/home/smartdisplay/rhasspy/profiles/en

20. Rhasspy start
 
 /home/smartdisplay/rhasspy/run-venv.sh
 
 web interface will be available at http://localhost:12101
 
 21. Go to Settings -> en -> Wake Word -> Select "Use snowboy on this device" and put wake word file to model name field-> Save settings
