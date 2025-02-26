#!/bin/bash
##################################
#      ***       ****
#          START
#      ***       ****
##################################
alias edit='gedit $HOME/.bashrc'
#alias edit='subl $HOME/.bashrc'
#alias edit='nano $HOME/.bashrc'

# daily notes 
#alias study='gedit $HOME/Desktop/IM_FILES/study.all'


##################################
# A good way to share bug details
#
alias paste-online='curl --data-binary @- https://paste.rs; echo'



#
# auto completion
# After running the above command, when you type:
# dothis [Tab]
# Bash will suggest now, tomorrow, or never as possible completions.
complete -W "now tomorrow never" dothis

#All file rename <filename.txt>
# file.png → file.png.txt
# doesn't remove the existing extension; instead, it appends .txt
alias all_into_txt='for file in *; do mv "$file" "${file%}.txt"; done'
#alias all_into_txt='for file in *; do mv "$file" "$file.txt"; done'
#alias all_into_txt='for file in *; do [[ "$file" == *.* ]] || mv "$file" "$file.txt"; done'
#alias all_into_txt='for file in *.*; do mv "$file" "${file%.*}.txt"; done'



#alias sl='softlanding'



##################
### Perfect
### BASIC
# debug
alias 1='xfwm4'
alias 2='xfdesktop'
alias 3='screenfetch'
alias mouse_fix='sudo bash $HOME/Desktop/MY_GIT/First_Step_Debian/reset_mouse.sh'
alias 4='mouse_fix'
### OPENGL bug
alias fixbug='LIBGL_ALWAYS_SOFTWARE=1 MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 '
alias f='fixbug'
################
alias poweroff='systemctl poweroff'
alias lsal='ls -al'
alias where='pwd'
alias c='clear'
alias m5='md5sum *'
alias o='xdg-open .'
#alias o='sudo xdg-open $PWD'
alias e='echo'
alias ins='sudo apt-get install'
alias fix='sudo apt-get install -f'
alias t='touch'
alias e='exit'
#alias q='exit'
#alias findport='sudo lsof -i :$1'



##################
### xfce4
alias paneledit='xfce4-panel --preferences'




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


################
#
# add TOdo
# Auto insatlling when OS chnage 
#
#
#
#
################
#
# gif download from giphy site
#
download_gif() {
    # Generate a random filename with 8 characters (alphanumeric)
    filename=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8).gif

    # Download the GIF using curl
    curl -o "$filename" "$1"

    # Output the filename for confirmation
    echo "Downloaded as $filename"
}





################
#Backup_function
################
bashrc_backup() {
    #    #
    # Copy .bashrc to backup location
    cp /home/cnc/.bashrc /home/cnc/Desktop/GIT_MAIN/silent/Alias_Backup/bashrc_backup
    #
    #
    # Back up software installation data, tracking changes day by day
    dpkg -l >/home/cnc/Desktop/GIT_MAIN/silent/Alias_Backup/dpkg_backup_home_cnc
    #
    #
    # Navigate to the desired directory
    # https://github.com/Tpj-root/silent
    # My private repositories
    # public key and private key are store in 
    # https://anotepad.com/notes/
    cd /home/cnc/Desktop/GIT_MAIN/silent/ || return
    #
    #
    # Run gitgo (assuming gitgo is defined as per previous instructions)
    gitgo
    #
    #
    # Push changes to the main branch
    git push origin main
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
## NETWORKING
## 
#########
alias netrestart='sudo systemctl restart NetworkManager'
alias findip='nmcli -p'
alias ip='nmcli -p'
#alias ip='ip addr show'
#alias iptables='/usr/sbin/iptables'
# arduino UDP ip address
alias ip2='sudo ip addr add 192.168.96.55/24 dev ens2'
# wifi password list
alias wifipass='cd /etc/NetworkManager/system-connections'
## forcefully kill any process using port 8000
alias k8000='sudo kill -9 $(lsof -t -i:8000)'


########## 
## python3
## 
#########
#alias p3='python3'
#alias py3='python3'
#alias p='python3'
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
#### LINUXCNC
############
source $HOME/Desktop/MY_GIT/First_Step_Debian/linuxcnc_alias.sh





############
#### git
############
#
alias gitwhois='git remote -v'
alias gitc='git clone'
alias gits='git status'
alias gitlog='git log'
alias gitd='git diff'
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
#alias addkey='ssh-add $HOME/Documents/KEY/id_rsa'
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

check_and_install_jocker() {
    # Check if the file /usr/local/bin/jocker.sh exists
    if [ ! -f /usr/local/bin/jocker.sh ]; then
        echo "jocker.sh not found, cloning repository..."

        # Create a temporary directory to store the cloned repo
        temp_dir=$(mktemp -d)

        # Clone the repository into the temporary directory
        git clone https://github.com/Tpj-root/And_Here_we_Go.git "$temp_dir"

        # Check if jocker.sh exists in the cloned repo
        if [ -f "$temp_dir/jocker.sh" ]; then
            # Copy jocker.sh to /usr/local/bin/
            sudo cp "$temp_dir/jocker.sh" /usr/local/bin/

            # Set executable permissions
            sudo chmod +x /usr/local/bin/jocker.sh

            echo "jocker.sh installed successfully."
        else
            # Print error if jocker.sh is not found in the cloned repo
            echo "Error: jocker.sh not found in the cloned repository."
        fi

        # Remove the temporary directory to clean up
        rm -rf "$temp_dir"
    else
        echo "jocker.sh already exists."
        sleep 0.5
        clear
    fi
}

# Call the function to execute the steps
check_and_install_jocker

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


###########################
#
#
# C3 Programming Language
# https://c3-lang.org/
#alias c3c='/home/cnc/Desktop/soft/c3/c3/c3c'






#################
#
# VLC playlist
#
#alias run='vlc /home/cnc/Downloads/SONGS/Boys/Ale_Ale.mp3'


#################
#
# transmission
#
# find the .torrent files
alias whereisT='cd $HOME/.config/transmission/torrents/'



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
alias tele='cd $HOME/Desktop/RUN_TIME/Telegram && ./Telegram'






##############
#
#
# cmake build
#
alias m='mkdir build && cd build && cmake .. && make'
alias rmm='cd .. && rm -rf build'
#alias db='rm -rf build'
#alias make_back='make > /dev/null 2>&1 &'



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
#alias qm='ls *.pro | while read line; do qmake $line; done && make'
#alias qm='ls *.pro | while read line; do qmake $line; make; done'



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
#source "$HOME/Desktop/RUN_TIME/emsdk-master/emsdk_env.sh"
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



#############
# 
#   dpkg -l
#
check_new_packages() {
    if [[ ! -f "$HOME/Desktop/MY_GIT/First_Step_Debian/24-02-2025_day_1st.txt" ]]; then
        echo "Error: Old package list not found!"
        return 1
    fi

    comm -13 <(awk '{print $2}' "$HOME/Desktop/MY_GIT/First_Step_Debian/24-02-2025_day_1st.txt" | sort) \
             <(dpkg -l | awk '{print $2}' | sort)
    # fix me
    #echo "packages count : $(check_new_packages | wc -l)"
}
#alias dpkg_update='check_new_packages'

#sudo nano /etc/apt/sources.list
#https://wiki.debian.org/SourcesList
#
#apt list --upgradable


##################################
# Title_screen
##################################
#
figlet shadow6
#
##################################
#      ***       ****
#           END
#      ***       ****
##################################

# TOdo
# Create a temporary user environment for me on someone else's system.
# Checking if basic software and libraries are installed

# Declare an indexed array with software names
declare -a index_array


##########
##
# Basic_software
#


index_array[0]="git"
index_array[1]="gedit"
index_array[2]="iptables"
index_array[3]="xclip"
index_array[4]="cmake"
index_array[5]="curl" # A command-line tool to transfer data to/from a server using various protocols 
index_array[6]="gcc"
index_array[7]="build-essential"
index_array[8]="evince"
index_array[9]="ruby-full"
index_array[10]="transmission"
index_array[11]="crunch" # A command-line utility for generating custom wordlists,
# To run Matrix Keyboards requires you to install and test "xdotool". 
# You can install it by typing "sudo apt install xdotool" in your console.
# linuxcnc
index_array[12]="xdotool" # xclip is a command-line utility that allows you to copy and paste text to and from the system clipboard in Linux.
index_array[13]="fonts-noto-color-emoji" # Font That Supports New Emojis



basic_software=(0 1 2 3 4 5 6 7 8 9 10 11 12 13)     # crunch, transmission




##########
##
# NetWorking
#

index_array[101]="wireshark"


#
#basic_software=(0 2)     # crunch, transmission
## Define categories with indices
#networking=(99)          # wireshark




# Function to check and install software
check_and_install() {
    local update_needed=false  # Flag to track if 'apt-get update' is needed
    local last_update_file="/var/log/last_apt_update"  # File to store last update date

    # Check if 'apt-get update' was run today
    if [ ! -f "$last_update_file" ] || [[ $(date +%F) != $(cat "$last_update_file") ]]; then
        update_needed=true  # Mark that an update is needed
    fi

    # Loop through each provided index to check/install software
    for index in "$@"; do
        package="${index_array[$index]}"  # Get package name from index_array

        # Check if the package is already installed
        if dpkg -l | grep -q "^ii  $package "; then
            echo "$package is already installed."  # Print status if installed
        else
            # Run 'apt-get update' only if it hasn't been run today
            if [ "$update_needed" = true ]; then
                echo "Running 'sudo apt-get update' (only once per day)..."
                sudo apt-get update  # Update package list
                date +%F | sudo tee "$last_update_file" > /dev/null  # Store today's date
                update_needed=false  # Ensure it doesn't run again for this execution
            fi

            echo "$package is not installed. Installing now..."
            sudo apt-get install -y "$package"  # Install the missing package
        fi
    done
}

# Run the function for selected categories
check_and_install "${basic_software[@]}"  # Check/install basic software
sleep 0.5
clear # 
figlet shadow6

#check_and_install "${networking[@]}"      # Check/install networking software



# add library temp
export CPLUS_INCLUDE_PATH=$HOME/Desktop/BUILD_FILES/boost_1_83_0
export LIBRARY_PATH=$HOME/Desktop/BUILD_FILES/boost_1_83_0/stage/lib
export LD_LIBRARY_PATH=$HOME/Desktop/BUILD_FILES/boost_1_83_0/stage/lib:$LD_LIBRARY_PATH