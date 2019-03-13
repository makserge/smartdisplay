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

sudo armbian-config

nand-sata-install

7. Remove SD card and boot from e-mmc

8. Login via SSH as smartdisplay

9. Update system

sudo apt update
sudo apt upgrade

10. Install desktop

sudo armbian-config

System->Minimal





