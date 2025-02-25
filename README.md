# First_Step_Debian
This is the procedure for installing Debian 12, both before and after installation, followed by some basic configuration needed for production work.


**Debian 12.9.0**

```
old
https://cdimage.debian.org/cdimage/archive/

https://cdimage.debian.org/cdimage/archive/11.6.0/amd64/iso-dvd/


https://cdimage.debian.org/debian-cd/current/amd64/bt-dvd/
https://cdimage.debian.org/debian-cd/current/amd64/bt-dvd/debian-12.9.0-amd64-DVD-1.iso.torrent

```

ISO TO USB_PENDRIVE


Double-check with: lsblk
```
cnc@debian:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 223.6G  0 disk 
├─sda1   8:1    0  27.9G  0 part /
├─sda2   8:2    0     1K  0 part 
├─sda5   8:5    0  93.1G  0 part 
├─sda6   8:6    0   976M  0 part [SWAP]
└─sda7   8:7    0 101.6G  0 part /home
sdb      8:16   1  28.9G  0 disk 
└─sdb1   8:17   1  28.9G  0 part 

```


```
sudo umount /dev/sdb1
sudo dd if=debian-12.9.0-amd64-DVD-1.iso of=/dev/sdb bs=4M status=progress && sync
lsblk
sudo fdisk -l /dev/sdb
sudo eject /dev/sdb
```


why ?? sync  ---> flush all buffers to disk

why ?? eject ---> safely remove the USB








**Step_0 :**


Modify package sources


```
sudo nano /etc/apt/sources.list
```

IF Debian 12/Bookworm (stable)

```
deb https://deb.debian.org/debian bookworm main non-free-firmware
deb-src https://deb.debian.org/debian bookworm main non-free-firmware

deb https://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src https://security.debian.org/debian-security bookworm-security main non-free-firmware

deb https://deb.debian.org/debian bookworm-updates main non-free-firmware
deb-src https://deb.debian.org/debian bookworm-updates main non-free-firmware

```


Debian 11/Bullseye (oldstable). 


```
deb https://deb.debian.org/debian bullseye main
deb-src https://deb.debian.org/debian bullseye main

deb https://deb.debian.org/debian-security/ bullseye-security main
deb-src https://deb.debian.org/debian-security/ bullseye-security main

deb https://deb.debian.org/debian bullseye-updates main
deb-src https://deb.debian.org/debian bullseye-updates main

```


```
Source : https://wiki.debian.org/SourcesList
```



**step_1 :**

create all these directories at once

The -p flag ensures that the directories are created if they don't exist.


```
mkdir -p MY_GIT RUN_TIME IM_FILES TEMP_FILES BUILD_FILES LIB_FILES
```


**Here are some basic MY directories and their purposes:**

 -  MY_GIT – Contains all my cloned repositories.
 -  RUN_TIME – Runtime application files.
 -  IM_FILES – Stores important notes; if the system crashes, only this folder needs to be backed up.
 -  TEMP_FILES – Temporary files (not needed).
 -  BUILD_FILES – Software build and binary files (not needed).
 -  LIB_FILES – Static and dynamic library files (so, not needed).



**step_2 :**


Install some basic software.

```
sudo apt-get install git \
gedit \
crunch \
iptables \
xclip \
cmake \
curl \
gcc \
build-essential \
evince
```

```
https://www.mozilla.org/en-US/firefox/new/
https://desktop.telegram.org/
https://github.com/arduino/arduino-cli/releases
```






**step_3 :**

Update some useful function and alias

```
gedit $HOME/.bashrc
```


```
# 
source $HOME/Desktop/MY_GIT/First_Step_Debian/alias_run.sh
```

**step_4 :**

Check SSH Key Permissions


```
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_rsa
#git config --global user.name "Tpj-root"
#git config --global user.email "trichy_hackerspace@outlook.com"
#alias addkey='ssh-add $HOME/Desktop/IM_FILES/id_rsa'
#
#Check SSH Key Permissions:
#Ensure that your SSH key has the correct permissions.
#chmod 600 $HOME/Desktop/IM_FILES/id_rsa
```




**step_5 :**

Time sync

```
timedatectl status
sudo timedatectl set-timezone Asia/Kolkata
```



**step_6 :**

packages can be upgraded

```
apt list --upgradable
```




**step_7 :**

```
sudo ln -s /usr/bin/python3 /usr/bin/python
```


**step_8 :**


**step_9 :**







```
This month, my hard disk crashed due to excessive data transfer while testing many build packages and libraries. 
As a result, I lost my notes. 
It's okay; I will start again from zero.
To prevent future crashes, I planned to sync my data with OneDrive cloud storage.
```


