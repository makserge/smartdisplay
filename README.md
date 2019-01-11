# SmartDisplay using MiniX Plus A10 and 3.5 inch HDMI IPS LCD

1. Download Armbian image
https://dl.armbian.com/cubieboard/Ubuntu_bionic_next.7z
from armbian.com

2. Flash using Etcher 
https://etcher.io 

3. Boot and login to console as

root / 1234

4. Set new root password

You are required to change your password immediately (root enforced)
Changing password for root.
(current) UNIX password:

5. Create a new user

 ...

Creating a new user account. Press <Ctrl-C> to abort

Please provide a username (eg. your forename): smartdisplay

6. Enable Wi-Fi

nmtui

Activate a connection->Choose network->Activate->Enter Wi-Fi password->Quit

7. Update system 
apt update
apt upgrade

8. Install XFCE desktop

armbian-config

System->Default - Install desktop with browser and extras

and wait until setup completes and system rebooted

9. Login via SSH as root

10. NodeJS

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

11. Install MagicMirror

git clone https://github.com/MichMich/MagicMirror

cd MagicMirror

npm install

cp config/config.js.sample config/config.js

DISPLAY=:0 nohup npm start &

12. Autostart MagicMirror

nano /home/smartdisplay/mm.sh

add
cd ~/MagicMirror
DISPLAY=:0 npm start

chmod +x ../mm.sh

In XFCE Applications->Settings->Session and Startup->Application Autostart->Add

Name: Magic Mirror
Command: /home/smartdisplay/mm.sh

Press OK
