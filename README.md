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

sudo apt-get install git gedit crunch iptables xclip cmake curl gcc build-essential

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
##################################
#      ***       ****
#          START
#      ***       ****
##################################


alias edit='gedit $HOME/.bashrc'
#alias edit='subl $HOME/.bashrc'


##################
### Perfect
### BASIC
alias where='pwd'
alias c='clear'
#alias ip='ip addr show'
#alias iptables='/usr/sbin/iptables'
alias o='xdg-open .'
alias e='echo'
alias ins='sudo apt-get install'
alias t='touch'
alias e='exit'
## forcefully kill any process using port 8000
alias k8000='sudo kill -9 $(lsof -t -i:8000)'


##########
#   MY own function list
##
## Quickly Extract Files
##
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "Unknown file type: $1" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

##########
## Directory copied to clipboard
##########
oc() {
    pwd
    pwd | xclip -selection clipboard
    echo "Directory copied to clipboard."
}


########## 
## python3
## 
#########
alias py='python3'
alias python='python3'
alias pyhttp='python3 -m http.server 8000'
#alias makepipreq='pip freeze > requirements.txt'


##########
# miniconda
##########
# cd $HOME/Desktop/RUN_TIME
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# bash Miniconda3-latest-Linux-x86_64.sh
# Miniconda3 will now be installed into this location:
# $HOME/miniconda3
#
#
alias miniconda_activate='source $HOME/miniconda3/bin/activate'
alias miniconda_deactivate='conda deactivate'
check_new_packages() {
    comm -13 <(sort $HOME/Desktop/MY_GIT/First_Step_Debian/installed_packages.txt) <(pip list | sort)
}
alias mini_check='check_new_packages'

############
#### git
############
#
alias whois='git remote -v'
alias gc='git clone'
alias gs='git status'
alias gd='git diff'
alias gg='gitgo'
alias gitsubdownload='git submodule update --init --recursive'
alias gitwho='git remote get-url origin'
alias gitrestore='git restore -- .'
alias gitaddkey='ssh-add $HOME/Desktop/IM_FILES/id_rsa'
#set private key and connect github profiles
#
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_rsa
#git config --global user.name "Tpj-root"
#git config --global user.email "trichy_hackerspace@outlook.com"
#alias addkey='ssh-add /home/cnc/Documents/KEY/id_rsa'
#
#Check SSH Key Permissions:
#Ensure that your SSH key has the correct permissions.
#chmod 600 $HOME/Desktop/IM_FILES/id_rsa
#
### git alias
function gitremote() {
    local repo="$1"
    git remote set-url origin "git@github.com:Tpj-root/${repo}"
    echo "Switched remote to git@github.com:Tpj-root/${repo}"
}
##########################################
# 1 -- > git clone "URL"
# 2 -- > cd <repo_name>
# 3 -- > git remote set-url origin "git@github.com:Tpj-root/${repo_name}"
# 4 -- > xdg-open .
# 5 -- > gedit README.md
#
function mygit() {
    if [ -z "$1" ]; then
        echo "Usage: mygit <repository_url>"
        echo "Example: mygit https://github.com/Tpj-root/PCB_Prototype_Board.git"
        return 1
    fi

    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)

    # Clone the repository
    git clone "$repo_url" || { echo "Failed to clone $repo_url"; return 1; }

    # Navigate into the repository directory
    cd "$repo_name" || { echo "Failed to cd into $repo_name"; return 1; }

    # Set the remote to SSH
    git remote set-url origin "git@github.com:Tpj-root/${repo_name}"
    echo "Switched remote to git@github.com:Tpj-root/${repo_name}"

    #open the current dir
    xdg-open .

    #open the Readme file
    gedit README.md
}
#function gitgo() V2.0
# git clone https://github.com/Tpj-root/And_Here_we_Go.git
# sudo cp jocker.sh /usr/local/bin/
# sudo chmod +x /usr/local/bin/jocker.sh
# then uncomment the last three lines
#
source /usr/local/bin/jocker.sh
alias githerewego='gitHereWeGo'
alias gitgo='gitHereWeGo'


###########################
#
#
# Firefox
# https://www.mozilla.org/en-US/firefox/linux/
#
alias fire='$HOME/Desktop/RUN_TIME/firefox/firefox'
#
#
#


############
# Arduino
# https://github.com/arduino/arduino-cli/releases
# 
#
#
#alias ard='$HOME/Desktop/RUN_TIME/arduino-cli_1.1.1_Linux_64bit/arduino-cli'
#alias arduino-cli='ard'


################
# 
#
# Download_full_playlist
# https://github.com/aandrew-me/ytDownloader/releases
#alias you='$HOME/Desktop/RUN_TIME/YTDownloader_Linux.AppImage'


###############
# https://desktop.telegram.org/
# 
#
#alias tele='cd $HOME/Desktop/RUN_TIME/Telegram && ./Telegram'


###############
# http://linuxcnc.org/
# https://github.com/LinuxCNC/linuxcnc
# Installing Tips
# https://docs.google.com/document/d/1jeV_4VKzVmOIzbB-ytcgsW2I_PhCm1x7oiw8VcLFdiY/edit?tab=t.0#heading=h.macj649sy0yq
# linuxcnc_update
#
#source /home/sab/Desktop/TRY_BUILD/linuxcnc-dev/scripts/rip-environment
#alias lc='linuxcnc'


##############
#
#
# cmake build
#
alias m='mkdir build && cd build && cmake .. && make'
alias rmm='cd .. && rm -rf build'


#############
#
# Trickster Arts Hackers
# 
# git clone https://github.com/Tpj-root/3.0.git
alias game='cd $HOME/Desktop/MY_GIT/3.0 && ruby sandbox.rb -c stone'


#############
#
#
# sublime_text
# subl
# https://gist.github.com/userlandkernel/b36acb1fcd2557a1a5cd608fc80e9c49
# curl https://download.sublimetext.com/files/sublime-text_build-3103_amd64.deb -o /tmp/sublimetext.deb
# sudo dpkg -i /tmp/sublimetext.deb
#alias sub='subl'


#############
# 
#
# tor-browser
# https://www.torproject.org/download/
#
#alias tor='cd /home/sab/Desktop/BUILD/tor/tor-browser-linux-x86_64-13.0.1/tor-browser && ./start-tor-browser.desktop'


#############
# Qt5 help
#
#
#
#
#
#alias mvplugin='ls *.so 1> /dev/null 2>&1 && mv *.so /usr/lib/x86_64-linux-gnu/qt5/plugins/designer/'


#############
#
# FPGA
# quartus
#
#
# #alias Q='/home/sab/altera/13.0sp1/quartus/bin/quartus --64bit'


##############
##
##  OpenCASCADE
##
#export CASROOT=/usr/local/bin
#export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
## Add Open CASCADE include path
#export CPLUS_INCLUDE_PATH=/usr/local/include/opencascade:$CPLUS_INCLUDE_PATH
#export LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
##
## 
## sudo lshw -short
## get the hardware details
##
## root to user permission
## sudo chown -R $USER:$USER 
##
##


#############
# git clone https://github.com/emscripten-core/emsdk.git
# cd emsdk
# ./emsdk install latest
# ./emsdk activate latest
# source ./emsdk_env.sh
## GUi
#source "/home/cnc/Desktop/RUN_TIME/emsdk-master/emsdk_env.sh"
#############
# 
#   raylib
#
#
# https://github.com/raysan5/raylib
# raylib run time build
# alias rbuild='g++ main* -o main -I/usr/local/include -L/usr/local/lib -lraylib -lm -lpthread -ldl -lX11'
#
# alias ray='raybuild'
raybuild() {
    rm -f *.out  # Remove all .out files in the directory
    g++ "$1"* -o "$1.out" -I/usr/local/include -L/usr/local/lib -lraylib -lm -lpthread -ldl -lX11
    
    if [ -f "$1.out" ]; then
        ./"$1.out"  # Run the program
        rm -f "$1.out"  # Remove the executable after it exits
    fi
}
##################################
#      ***       ****
#          END
#      ***       ****
##################################
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


**step_7 :**


**step_8 :**


**step_9 :**







```
This month, my hard disk crashed due to excessive data transfer while testing many build packages and libraries. 
As a result, I lost my notes. 
It's okay; I will start again from zero.
To prevent future crashes, I planned to sync my data with OneDrive cloud storage.
```


