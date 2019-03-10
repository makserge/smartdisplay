# SmartDisplay using BananaPI M2 Zero and 3.5 inch HDMI IPS LCD

1. Download image

`https://dev.banana-pi.org.cn/Image/BPI-M2Z/Armbian/2017-12-04-Armbian_5.36_Bananapim2zero_Ubuntu_xenial_next_4.14.3_desktop_preview_build_by_bpi.img.img.zip

2. Flash using Etcher or Rufus

3. Login as root / 1234

and change root password

4. Add new user smartdisplay

5. In desktop environment start terminal

6. Enable Wi-Fi

sudo nmtui

Activate connection->select network->activate->enter password->ok->quit

7. Login to SSH as smartdisplay

8. Set resolution to 640X480

sudo nano /boot/armbianEnv.txt

add
extraargs=drm_kms_helper.edid_firmware=HDMI-A-1:edid/640x480.bin video=HDMI-A-1:640x480@60

sudo reboot 

9. Cleanup software

sudo apt-get autoremove libreoffice-\* -y
sudo apt-get autoremove mirage cups thunderbird hexchat mpv galculator -y
sudo apt-get purge --auto-remove mirage cups thunderbird hexchat mpv galculator

10. Cleanup autostart entries

Applications->Settings->Session and Startup

Uncheck

Blueman Applet
Network
Print Queue Applet


11. Change timezone

sudo armbian-config

Personal->Timezone->Europe->Kiev->Ok->Cancel

12. Do not update system kernel (4.15 kernel broke resolution config) 

sudo armbian-config

System->Freeze->Freeze

13. Update system

sudo apt update
sudo apt upgrade -y

14. Pulseuadio / Alsa config for Ps3 eye

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


15. Check audio config
 
arecord -f S16_LE -r 16000 -c 1 --buffer-size=204800 -v sample.wav 
aplay sample.wav 

16. Install snowboy

sudo apt install libatlas-base-dev portaudio19-dev python-dev python-pip -y
pip install --upgrade pip

python -m pip uninstall pip && sudo apt install python-pip --reinstall

pip install setuptools
pip install pyaudio

wget http://downloads.sourceforge.net/swig/swig-3.0.10.tar.gz
sudo apt install libpcre3 libpcre3-dev
tar xvzf swig-3.0.10.tar.gz
cd swig-3.0.10
./configure --prefix=/usr                  \
        --without-clisp                    \
        --without-maximum-compile-warnings &&
make
sudo make install
cd ..

wget https://github.com/Kitt-AI/snowboy/archive/master.zip
unzip master.zip
mv snowboy-master snowboy
cd snowboy

cd swig/Python
make
cd ..
cd ..

17. Test snowboy

python examples/Python/demo2.py resources/models/snowboy.umdl resources/models/subex.umdl

18. Test google speech recognition

sudo apt install flac

pip install monotonic
pip --no-cache-dir install SpeechRecognition

pip install --upgrade google-api-python-client


python examples/Python/demo4.py resources/models/smart_mirror.umdl

19. Set language for Google speech to text

nano examples/Python/demo4.py

change

print(r.recognize_google(audio))

to 

print(r.recognize_google(audio, language="ru-RU"))
