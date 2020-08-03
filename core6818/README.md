1. Download s5p6818-eflasher-lubuntu-desktop-xenial-4.4-armhf-20191227.img.zip
(https://drive.google.com/file/d/1_Gr7INH54dJaxN-1V1deBdec_WSfSwMp/view?usp=sharing)
 from https://drive.google.com/drive/folders/1P-Vky3I785gZtqqEeSHPXR-mxzT84CH1

2. Flash TF card using Etcher https://etcher.io or

rufus http://rufus.akeo.ie/downloads/rufus-2.11p.exe

3. Insert TF card, press Boot and switch on board and release Boot
login to console 

root / fa

4. Run eflasher

eflasher

ctp = 1
----------------------------------------------------------------------
  EFlasher v1.2 b191226 running on NanoPC-T3
    Doc: http://wiki.friendlyarm.com/wiki/index.php/EFlasher
    eMMC: 7.28 GB
----------------------------------------------------------------------
  # Select an OS to install:
    1) Lubuntu Desktop

  # Select your backup target device:
     tf) [*] TF card  (/dev/mmcblk0p1 - 2.32 GB free - 6.36 GB total - fuseblk)
    usb) [ ] USB disk  (<none>)

  # Backup eMMC flash to TF card:
    Not enough free disk space on your TF card

  # Restore eMMC flash from backup file:
    No backup files found

  # Configure automatic job:
    aui) Automatic installing (Curr:Off)
    aur) Automatic restoring (Curr:Off)

  # Format drive
    ftf) Format TF card back to original size
----------------------------------------------------------------------
>>> Enter an option (1/tf/usb/aui/aur/ftf) :

1

----------------------------------------------------------------------
  Ready to Go with Lubuntu
----------------------------------------------------------------------
  Ready to install
  Version:
                2019-12-27
  Path:
                /mnt/sdcard/lubuntu
  Image files:
                bl1-mmcboot.bin 21.08 KB
                fip-loader.img 272.50 KB
                fip-nonsecure.img 464.04 KB
                fip-secure.img 251.11 KB
                boot.img 26.11 MB
                rootfs.img 4.01 GB
                userdata.img 5.62 MB

  Total size:
                4.04 GB
  Kernel parameter:

bootargs console=ttySAC0,115200n8 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait data=/dev/mmcblk0p3 init=/sbin/init loglevel=7 printk.time=1 consoleblank=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1
bootdelay 1

----------------------------------------------------------------------
>>> Do you wish to continue? (yes/no) :

yes

----------------------------------------------------------------------
  Installing Lubuntu
----------------------------------------------------------------------
  Speed: 19.25 MB/s
  Remaining Time: 00:03:12
  [==__________________]  10%
----------------------------------------------------------------------
  >>>Enter "c" to cancel.

----------------------------------------------------------------------
  Installing Lubuntu
----------------------------------------------------------------------
  Finish, please reboot system and start from the eMMC.
----------------------------------------------------------------------
>>> Enter an option (poweroff/reboot) , or "c" to return:

poweroff

5. Remove TF card and switch power on and wait until board boot


Ubuntu 16.04 LTS FriendlyELEC ttySAC0

Default Login:
Username = pi
Password = pi

FriendlyELEC login:

6. Login as root / fa

Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.172-s5p6818 armv7l)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

7. Set new root password

passwd
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully

8. Enable Wi-Fi
nmtui

Activate a connection->Choose network->Activate->Enter Wi-Fi password->Ok->Quit


9. Cleanup software


rm -rf /home/pi/demo.mp4
rm -rf /var/cache/apt

10. Disable bluetooth

systemctl stop bluetooth
systemctl disable bluetooth

11. Disable gpsd

systemctl stop gpsd
systemctl disable gpsd

12. Disable whoopsie

systemctl stop whoopsie
systemctl disable whoopsie

apt autoremove --purge whoopsie

13. Disable automatic updates

nano /etc/apt/apt.conf.d/20auto-upgrades

replace

APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";

to 

APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";

14. Change timezone

timedatectl set-timezone Europe/Kiev

15. Add user smartmirror

adduser smartmirror

16. Change autologin user 

nano /usr/share/lightdm/lightdm.conf.d/20-lubuntu.conf

replace

autologin-user=pi

to 

autologin-user=smartmirror
autologin-user-timeout=0

17. Install NodeJS

apt update
apt install curl
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

apt install -y nodejs

18. Install MagicMirror

Login as smartmirror

git clone https://github.com/MichMich/MagicMirror

cd MagicMirror

npm install

//nano config/config.js

cd vendor
npm install
cd ..

npm start

15. Pulseuadio / Alsa config for Ps3 eye

nano /usr/share/pulseaudio/alsa-mixer/profile-sets/default.conf

add

[Mapping analog-4-channel-input]
# Alsa doesn't currently provide any better device name than "hw" for 4-channel
# input. If this causes trouble at some point, then we will need to get a new
# device name standardized in alsa.
device-strings = hw:%f
channel-map = aux0,aux1,aux2,aux3
priority = 1
direction = input

reboot

Check config:
pactl set-card-profile 0 input:analog-4-channel-input



sudo nano /etc/pulse/default.pa

add

set-card-profile 0 input:analog-4-channel-input

nano /etc/asound.conf

pcm.pulse {
    type pulse
}

ctl.pulse {
    type pulse
}

pcm.!default {
    type pulse
}

ctl.!default {
    type pulse
}

sudo nano /usr/share/alsa/alsa.conf

comment out 

defaults.pcm.surround21.card defaults.pcm.card
defaults.pcm.surround41.card defaults.pcm.card
defaults.pcm.surround50.card defaults.pcm.card
defaults.pcm.surround51.card defaults.pcm.card
defaults.pcm.surround71.card defaults.pcm.card

pcm.front cards.pcm.front
pcm.rear cards.pcm.rear
pcm.center_lfe cards.pcm.center_lfe
pcm.side cards.pcm.side
pcm.surround21 cards.pcm.surround21
pcm.surround40 cards.pcm.surround40
pcm.surround41 cards.pcm.surround41
pcm.surround50 cards.pcm.surround50
pcm.surround51 cards.pcm.surround51
pcm.surround71 cards.pcm.surround71
pcm.iec958 cards.pcm.iec958
pcm.spdif iec958
pcm.hdmi cards.pcm.hdmi
pcm.modem cards.pcm.modem
pcm.phoneline cards.pcm.phoneline


reboot

17. Check audio config
 
arecord -f S16_LE -r 16000 -c 1 --buffer-size=204800 -v sample.wav 
aplay sample.wav 

18. Get Rhasspy

git clone https://github.com/synesthesiam/rhasspy.git

cd rhasspy/

19. Patch Snowboy for arm64

tar -xf etc/snowboy-1.3.0.tar.gz
cd snowboy-1.3.0/swig/Python3

nano Makefile

replace 
SNOWBOYDETECTLIBFILE = $(TOPDIR)/lib/ubuntu64/libsnowboy-detect.a

to
SNOWBOYDETECTLIBFILE = $(TOPDIR)/lib/aarch64-ubuntu1604/libsnowboy-detect.a

cd ..
cd..
cd..

mv etc/snowboy-1.3.0.tar.gz etc/snowboy-1.3.0.tar.gz.old

tar -zcf etc/snowboy-1.3.0.tar.gz snowboy-1.3.0/

rm -rf snowboy-1.3.0

20. Setup Rhasspy
./create-venv.sh


21. Put Snowboy wake word to

/home/smartdisplay/rhasspy/profiles/en

22. Start Rhasspy
 
/home/smartdisplay/rhasspy/run-venv.sh
 
Web interface will be available at http://localhost:12101



wget https://s3-us-west-2.amazonaws.com/snowboy/snowboy-releases/pine64-debian-jessie-1.1.1.tar.bz2
tar xjvf pine64-debian-jessie-1.1.1.tar.bz2
cd pine64-debian-jessie-1.1.1/

Grab _snowboydetect.so and replace default one from 32 bit Snowboy package

sudo apt-get install libatlas-base-dev
sudo apt-get install portaudio19-dev
sudo apt-get install python-dev
sudo apt-get install python-pip
pip install --upgrade pip
pip install setuptools
pip install wheel
pip install pyaudio
