1. Download https://dl.armbian.com/orangepizeroplus2-h5/Ubuntu_bionic_next.7z
 from armbian.com

2. Flash using Etcher https://etcher.io or

rufus http://rufus.akeo.ie/downloads/rufus-2.11p.exe

3 Boot and login to console (from MacOS)
screen /dev/cu.usbmodem14231 115200 or

screen /dev/cu.SLAB_USBtoUART 115200 for CP2102 USB-UART

root / 1234

4. Set new root password
You are required to change your password immediately (root enforced) Changing password for root. (current) UNIX password:

Create a new user
...

Creating a new user account. Press to abort

Please provide a username (eg. your forename): smartdisplay

4. Enable Wi-Fi
nmtui

Activate a connection->Choose network->Activate->Enter Wi-Fi password->Quit

5. Login via SSH as smartdisplay

6. Transfer system to e-mmc

nand-sata-install

Boot from emmc->Ok->Choose ext4->Ok->Power off

7. Remove SD card and boot from e-mmc

8. Login via SSH as smartdisplay

9. Update system

sudo apt update
sudo apt upgrade

10. Install desktop

sudo armbian-config

System->Minimal

11. Set resolution to 640X480

sudo nano /boot/armbianEnv.txt

add
extraargs=drm_kms_helper.edid_firmware=HDMI-A-1:edid/640x480.bin video=HDMI-A-1:640x480@60

sudo reboot 

12. Cleanup autostart entries

Applications->Settings->Session and Startup->Application Autostart

Uncheck

AT SPI D-Bus Bus
Blueman Applet
Network
User folders update

Applications->Settings->Session and Startup->Session
Thunar -> Double click  on "If running" and select "Never"->Save Session

13. Disable bluetooth

sudo nano /etc/bluetooth/main.conf

replace
AutoEnable=true

to
#AutoEnable=true

sudo systemctl stop bluetooth
sudo systemctl disable bluetooth

14. Disable automatic updates

sudo nano /etc/apt/apt.conf.d/20auto-upgrades

replace

APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";

to 

APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";

15. Change timezone

sudo armbian-config

Personal->Timezone->Europe->Kiev->Ok->Cancel

16. Pulseuadio / Alsa config for Ps3 eye

sudo nano /usr/share/pulseaudio/alsa-mixer/profile-sets/default.conf

add

[Mapping analog-4-channel-input]
# Alsa doesn't currently provide any better device name than "hw" for 4-channel
# input. If this causes trouble at some point, then we will need to get a new
# device name standardized in alsa.
device-strings = hw:%f
channel-map = aux0,aux1,aux2,aux3
priority = 1
direction = input

sudo reboot

Check config:
pactl set-card-profile 0 input:analog-4-channel-input



sudo nano /etc/pulse/default.pa

add

set-card-profile 0 input:analog-4-channel-input

sudo nano /etc/asound.conf

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


sudo reboot

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
