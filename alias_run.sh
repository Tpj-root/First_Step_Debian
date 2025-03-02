#!/bin/bash
##########################################################
#/*
# * Copyright (C) 2025 [Tpj-root]
# * https://github.com/Tpj-root
# *
# * This program is free software; you can redistribute it and/or modify
# * it under the terms of the GNU General Public License version 2
# * as published by the Free Software Foundation.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# * GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with this program; if not, see <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>.
# */
#
#
# Linux apps that run anywhere
# https://appimage.org/
# https://www.appimagehub.com/
# https://appimage.github.io/apps/
#
# Beyond Linux® From Scratch (System V Edition)
# https://www.linuxfromscratch.org/blfs/view/svn/index.html
##################################
#          START
##################################

version="1.0"
#echo "Script Name: ${BASH_SOURCE[0]}"


## Enabled for only one time for insatinng basicsoftwares
## Enabled or Disable
SoftWare_Installing=0  # 1 means enabled, 0 means disabled
Jocker_Installing=0 # 1 means enabled, 0 means disabled
###
Title_screen=0 # 1 means enabled, 0 means disabled
Prompt_Animation=0


# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'   # Gray (Light Black)
RESET='\033[0m'
BLINK='\033[5m'



print_random_color() {
    local message=$1
    local random_color=${colors[$RANDOM % ${#colors[@]}]}
    echo -e "${random_color}${message}${RESET}"
}

print_special_color() {
    local message=$1
    local random_color=${BLUE}
    echo -e "${random_color}${message}${RESET}"
}


title_fun() {

print_special_color " .d8888. db   db  .d8b.  d8888b.  .d88b.  db   d8b   db " 
print_special_color " 88'  YP 88   88 d8' \`8b 88  \`8D .8P  Y8. 88   I8I   88 " 
print_special_color " \`8bo.   88ooo88 88ooo88 88   88 88    88 88   I8I   88 " 
print_special_color "   \`Y8b. 88~~~88 88~~~88 88   88 88    88 Y8   I8I   88 " 
print_special_color " db   8D 88   88 88   88 88  .8D \`8b  d8' \`8b d8'8b d8' " 
print_special_color " \`8888Y' YP   YP YP   YP Y8888D'  \`Y88P'   \`8b8' \`8d8'  " 
print_special_color "                          bash ${version}    "
}


why() {
echo -e ${GREEN} "The journey of a thousand miles begins with a single step."
echo -e ${GREEN} "The reason to start is to open the door to the possibilities that lie ahead."
}



# Function to check the condition SoftWare_Installing 
check_the_condition_Title_screen() {
    if [[ "$Title_screen" -eq 1 ]]; then
        # Run the function for selected categories
		title_fun
		why
    fi
}

check_the_condition_Title_screen

# 
# Function to check the condition Animation prompt
check_the_condition_Animation() {
    if [[ "$Prompt_Animation" -eq 1 ]]; then
        # Run the function for selected categories

		spinner1() {
		    local chars="/-\|"
		    while true; do
		        for (( i=0; i<${#chars}; i++ )); do
		            echo -ne "${chars:$i:1}" "\r"
		            sleep 0.1
		        done
		    done
		}

		#export PS1="🅂 🅷 🅰 🅳 🅾 🆆 @ bash 🡆 {$spinner}"
		#spinner  # Run the spinner (Press Ctrl+C to stop)
		#spinner1 &


		###############
		# change your Bash terminal prompt 
		#
		#export PS1="👽@debian:\w$ "
		#export PS1="🅂 🅷 🅰 🅳 🅾 🆆 @ bash 🡆 💀"
		#export PS1="🅂 🅷 🅰 🅳 🅾 🆆 @ bash 🡆 👽"
		#export PS1="🅂 🅷 🅰 🅳 🅾 🆆 @ bash 🡆 {$spinner}"
		#spinner

		spinner() {
		    local chars=("👽" "💀" "🐺" "👻")
		    echo -n "${chars[$((SECONDS % ${#chars[@]}))]}"
		}

		export PS1="${GRAY}${BLINK}🅂 🅷 🅰 🅳 🅾 🆆 ${RESET} @ bash $(spinner) 🡆 "
		#export PS1='🅂 🅷 🅰 🅳 🅾 🆆 @ bash $(spinner) 🡆 '

		print_colors() {
		    for i in {0..107}; do
		        printf "\e[${i}m%-10s \e[0m" "[$i]"
		        if (( (i + 1) % 8 == 0 )); then
		            echo  # New line after every 8 colors
		        fi
		    done
		}

		#print_colors
		#figlet shad
    fi
}

check_the_condition_Animation




#alias edit='gedit $HOME/.bashrc'
#alias edit='subl $HOME/.bashrc'
#alias edit='nano $HOME/.bashrc'

# Function to set the 'edit' alias based on available text editors
set_edit_alias() {
    # Check if 'subl' (Sublime Text) is installed and available
    if command -v subl &>/dev/null; then
        #alias edit='subl $HOME/.bashrc'  # Use Sublime Text if available
        alias edit='subl $HOME/Desktop/MY_GIT/First_Step_Debian/alias_run.sh'
    # If 'subl' is not found, check for 'gedit' (GNOME Text Editor)
    elif command -v gedit &>/dev/null; then
        alias edit='gedit $HOME/.bashrc'  # Use Gedit if available
    # If neither 'subl' nor 'gedit' is available, fallback to 'nano'
    else
        alias edit='nano $HOME/.bashrc'  # Use Nano as the last resort
    fi
}

# Call the function to set the alias when the shell starts
set_edit_alias



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
alias ed='sudo subl $1'
#alias q='exit'
#alias findport='sudo lsof -i :$1'


# xclock
# https://github.com/ereslibre/x11/tree/master
# https://gitlab.freedesktop.org/xorg/app/xclock
# https://www.linuxfromscratch.org/blfs/view/svn/x/xclock.html
#



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



# mtouch <filename>
mtouch() {
    if command -v subl &>/dev/null; then
        touch "$1" && subl "$1"
    # If 'subl' is not found, check for 'gedit' (GNOME Text Editor)
    elif command -v gedit &>/dev/null; then
        touch "$1" && gedit "$1"
    # If neither 'subl' nor 'gedit' is available, fallback to 'nano'
    else
        touch "$1" && nano "$1"
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
# Bug in Auto-Completion
#source $HOME/Desktop/MY_GIT/First_Step_Debian/linuxcnc_alias.sh
###############
# http://linuxcnc.org/
# https://github.com/LinuxCNC/linuxcnc
# Installing Tips
# https://docs.google.com/document/d/1jeV_4VKzVmOIzbB-ytcgsW2I_PhCm1x7oiw8VcLFdiY/edit?tab=t.0#heading=h.macj649sy0yq
# linuxcnc_update
#
#source /home/sab/Desktop/TRY_BUILD/linuxcnc-dev/scripts/rip-environment
#alias lc='linuxcnc'
#alias h='halcmd'
#alias hs='halshow'
#alias hk='halrun -U'
#alias halkill=' halrun -U'
#alias mvso=' ls *.so | while read line; do sudo mv $line $HOME/Desktop/CNC_BUILD/linuxcnc-dev/rtlib/; done'
## Perfect
## linuxcnc alias
#alias halkill='halrun -U'


mvcomp() {
    if [ -z "$1" ]; then
        echo "Usage: mvcomp <filename>"
        return 1
    fi

    local target_dir="/home/sab/Desktop/TRY_BUILD/linuxcnc-dev/rtlib/"
    local filename="$1"

    # Check if the file exists
    if [ ! -f "$filename" ]; then
        echo "Error: File '$filename' does not exist."
        return 1
    fi

    # Check if the file is a .so file
    if [[ "$filename" != *.so ]]; then
        echo "Error: '$filename' is not a .so file."
        return 1
    fi

    # Move the file
    mv "$filename" "$target_dir"
    echo "Moved '$filename' to $target_dir"
}

#####
# testing script
#




################################################
#### Emoji
############
#source $HOME/Desktop/MY_GIT/First_Step_Debian/emoji_pack.sh
# UTF-8 is the encoding that supports all Unicode characters, 
# but displaying emojis depends on the installed font. 
# Not all fonts include all Unicode characters, especially emojis.

# cnc@debian:~$ fc-list | grep -i emoji
# /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf: Noto Color Emoji:style=Regular
# 
#
#print_emoji() {
#    local code=$1
#    printf "U+%04X: \U$(printf "%08x" "$code")\n" "$code"
#}


print_emoji() {
    local code=$1
    printf "\U$(printf "%08x" "$code")" "$code"
}

# Example usage: # U+2705: ✅
GreenTick() {
    print_emoji 0x2705
}

# U+274C: ❌
RedTick() {
    print_emoji 0x274C
}

# U+1F47D: 👽
Alien() {
    print_emoji 0x1F47D
}


# sample
#GreenTick
#echo "$(GreenTick) $package is already installed."
#U+2753: ❓
#U+1F608: 😈
#U+1F607: 😇
#U+2700: ✀
#U+1F3A7: 🎧
#U+1F3B5: 🎵
#U+1F43A: 🐺
#U+1F47E: 👾
#U+1F47F: 👿
#U+1F480: 💀
#U+1F4F7: 📷
################################################



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




##########################################
#     jocker start
#
##########################################
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


# Function to check the condition SoftWare_Installing 
check_the_condition_jocker() {
    if [[ "$Jocker_Installing" -eq 1 ]]; then
        # Run the function for selected categories
		# Call the function to execute the steps
		check_and_install_jocker
    fi
}

check_the_condition_jocker

#function gitgo() V2.0
# git clone https://github.com/Tpj-root/And_Here_we_Go.git
# sudo cp jocker.sh /usr/local/bin/
# sudo chmod +x /usr/local/bin/jocker.sh
# then uncomment the last three lines
#
source /usr/local/bin/jocker.sh
alias githerewego='gitHereWeGo'
alias gitgo='gitHereWeGo'
##########################################
#      jocker end
##########################################
##########################################
#      apache start
##########################################

check_and_setup_apache() {
    # Check if apache2 command is available
    if ! command -v apache2 &>/dev/null; then
        echo "apache2 command not found, trying /usr/sbin/apache2..."
        
        # Check if apache2 exists in /usr/sbin
        if [ -x /usr/sbin/apache2 ]; then
            echo "Using /usr/sbin/apache2"
            /usr/sbin/apache2 -v
        else
            echo "apache2 not found in PATH or /usr/sbin. Adding /usr/sbin to PATH..."
            export PATH=$PATH:/usr/sbin
            
            # Check again after updating PATH
            if ! command -v apache2 &>/dev/null && [ ! -x /usr/sbin/apache2 ]; then
                echo "Apache2 is still not available, installing required packages..."
                sudo apt install apache2-bin apache2-utils -y
            fi
        fi
    else
        echo "apache2 is available:"
        apache2 -v
    fi
}

# Run the function
export PATH=$PATH:/usr/sbin
check_and_setup_apache
sleep 1
clear
##########################################
#      apache end
##########################################

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
# https://github.com/Tpj-root/Arduino_CLI
#
#
#alias ard='$HOME/Desktop/RUN_TIME/arduino-cli_1.1.1_Linux_64bit/arduino-cli'
#alias arduino-cli='ard'

arduino-cli() {
    # Define the file path
    local dir="$HOME/Desktop/RUN_TIME"
    local archive="$dir/arduino-cli_1.2.0_Linux_64bit.tar.gz"
    local file="$dir/arduino-cli"
    local url="https://github.com/arduino/arduino-cli/releases/download/v1.2.0/arduino-cli_1.2.0_Linux_64bit.tar.gz"

    # Ensure the directory exists
    mkdir -p "$dir"

    # Check if the archive exists, download if not
    if [[ ! -f "$archive" ]]; then
        echo "Archive not found. Downloading..."
        wget -O "$archive" "$url" || { echo "Download failed!"; return 1; }
    fi

    # Extract the archive if the executable doesn't exist
    if [[ ! -f "$file" ]]; then
        echo "Extracting archive..."
        tar -xzf "$archive" -C "$dir" || { echo "Extraction failed!"; return 1; }
    fi

    # Ensure the file is executable
    if [[ ! -x "$file" ]]; then
        echo "Setting executable permission..."
        chmod +x "$file"
    fi

    # Run the executable
    echo "Running $file..."
    "$file"
}

#arduino-cli


################
# 
# #alias you='$HOME/Desktop/RUN_TIME/YTDownloader_Linux.AppImage'
# Download_full_playlist
# https://github.com/aandrew-me/ytDownloader/releases
# make function if 

# Function to check and run YTDownloader_Linux.AppImage
you() {
    # Define the file path
    local file="$HOME/Desktop/RUN_TIME/YTDownloader_Linux.AppImage"
    local url="https://github.com/aandrew-me/ytDownloader/releases/download/v3.19.0/YTDownloader_Linux.AppImage"
    local dir="$HOME/Desktop/RUN_TIME"

    # Ensure the directory exists
    mkdir -p "$dir"

    # Check if the file exists, download if not
    if [[ ! -f "$file" ]]; then
        echo "File not found. Downloading..."
        wget -O "$file" "$url" || { echo "Download failed!"; return 1; }
    fi

    # Ensure the file is executable
    if [[ ! -x "$file" ]]; then
        echo "Setting executable permission..."
        chmod +x "$file"
    fi

    # Run the AppImage
    echo "Running $file..."
    "$file"
}


# Execute the function
#you

################







################
# AnyDISK
# 

myanydesk() {
    # Set variables
    local dir="$HOME/Desktop/RUN_TIME"
    local file="$dir/anydesk_6.4.2-1_amd64.deb"
    local url="https://download.anydesk.com/linux/anydesk_6.4.2-1_amd64.deb"

    # Ensure the directory exists
    mkdir -p "$dir"

    # Download if the file does not exist
    if [[ ! -f "$file" ]]; then
        echo "File not found. Downloading to $dir..."
        wget -O "$file" "$url" || { echo "Download failed!"; return 1; }
    else
        echo "File already exists: $file"
    fi

    # Check if AnyDesk is installed
    if ! dpkg -l | grep -q "anydesk"; then
        echo "Installing $file..."
        sudo dpkg -i "$file" || { echo "Installation failed!"; return 1; }
        echo "Restarting AnyDesk service..."
        sudo systemctl restart anydesk.service || echo "Warning: Failed to restart AnyDesk."
        echo "AnyDesk installation completed."
    else
        echo "AnyDesk is already installed."
    fi

    # Ensure DISPLAY variable is set
    export DISPLAY=:0

    # Run AnyDesk
    anydesk &>/dev/null &
}


################
# 
# A Hex Editor for Reverse Engineers, Programmers
# https://github.com/WerWolv/ImHex
# https://github.com/WerWolv/ImHex/releases
# 

imhex() {
    # Define the file path
    local file="$HOME/Desktop/RUN_TIME/imhex-1.37.4-x86_64.AppImage"
    local url="https://github.com/WerWolv/ImHex/releases/download/v1.37.4/imhex-1.37.4-x86_64.AppImage"
    local dir="$HOME/Desktop/RUN_TIME"

    # Ensure the directory exists
    mkdir -p "$dir"

    # Check if the file exists, download if not
    if [[ ! -f "$file" ]]; then
        echo "File not found. Downloading..."
        wget -O "$file" "$url" || { echo "Download failed!"; return 1; }
    fi

    # Ensure the file is executable
    if [[ ! -x "$file" ]]; then
        echo "Setting executable permission..."
        chmod +x "$file"
    fi

    # Run the AppImage
    echo "Running $file..."
    "$file"
}



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
# figlet shadow6
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
index_array[14]="rlwrap" # rlwrap is a command-line utility that adds readline support
index_array[14]="vlc" # The VLC media player
index_array[15]="gimp" # gimp - an image manipulation and paint program.

# libjpeg-turbo-progs
# jpegtran -copy none -optimize -outfile fixed.jpg DSCF0075.jpg
#index_array[16]="libjpeg-progs" # Lossless Repair
index_array[16]="libjpeg-turbo-progs" # Lossless Repair
# imagemagick
# convert DSCF0075.jpg fixed.png
index_array[17]="imagemagick" #  Convert to PNG
index_array[18]="tmux" # terminal multiplexer
# Move Terminal to (X=100, Y=100) with size (Width=800, Height=600)
# wmctrl -r :ACTIVE: -e 0,100,100,800,600
index_array[19]="wmctrl" # wmctrl - interact with a EWMH/NetWM compatible X Window Manager.
# xdotool getactivewindow windowmove 100 100 windowsize 800 600
index_array[20]="xdotool" # wmctrl - interact with a EWMH/NetWM compatible X Window Manager.


### 
basic_software=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)     # crunch, transmission




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
            #echo "$package is already installed."  # Print status if installed
            # update emojitick
            echo "$(GreenTick) $package is already installed."
        else
            # Run 'apt-get update' only if it hasn't been run today
            if [ "$update_needed" = true ]; then
                echo "Running 'sudo apt-get update' (only once per day)..."
                #sudo apt-get update  # Update package list
                date +%F | sudo tee "$last_update_file" > /dev/null  # Store today's date
                update_needed=false  # Ensure it doesn't run again for this execution
            fi

            echo "$package is not installed. Installing now..."
            # update emoji style
            echo "$(RedTick) $package is not installed. Installing now..."
            sudo apt-get install -y "$package"  # Install the missing package
        fi
    done
}

# FIX ME
#if ! dpkg -s libjpeg-turbo-progs &>/dev/null; then
#    echo "❌ libjpeg-turbo-progs is not installed. Installing now..."
#    sudo apt install -y libjpeg-turbo-progs
#else
#    echo "✅ libjpeg-turbo-progs is already installed."
#fi





# Function to check the condition SoftWare_Installing 
check_the_condition_SoftWare() {
    if [[ "$SoftWare_Installing" -eq 1 ]]; then
        # Run the function for selected categories
		check_and_install "${basic_software[@]}"  # Check/install basic software
		sleep 2
		clear # 
    fi
}



# Run the function
check_the_condition_SoftWare





#check_and_install "${networking[@]}"      # Check/install networking software

# --geometry=COLUMNSxROWS+X+Y
#open_terminals() {
#    xfce4-terminal --geometry=80x24+100+100 --title="Terminal 1" &
#    xfce4-terminal --geometry=100x30+500+200 --title="Terminal 2" &
#}


# 1920*1080 WIDTH*HEIGHT
open_terminals_left_2() {
    SCREEN_WIDTH=$(xdotool getdisplaygeometry | awk '{print $1}')
    SCREEN_HEIGHT=$(xdotool getdisplaygeometry | awk '{print $2}')
    
    SCREEN_PX=24

    TERM_WIDTH=$((SCREEN_WIDTH / ${SCREEN_PX}))
    TERM_HEIGHT=$(awk "BEGIN {print $SCREEN_HEIGHT / ($SCREEN_PX * 2.5)}")

    #TERM_WIDTH=$((SCREEN_WIDTH ))
    #TERM_HEIGHT=$((SCREEN_HEIGHT ))


    # Debug help
    # echo "${TERM_WIDTH}"
    # echo "${TERM_HEIGHT}"
    # xdotool getactivewindow getwindowgeometry

    xfce4-terminal --geometry=${TERM_WIDTH}x${TERM_HEIGHT}+0+0 --title="Top Terminal" &
# run the command 
#	xfce4-terminal --geometry=${TERM_WIDTH}x${TERM_HEIGHT}+0+0 --title="Top Terminal" -e "bash -c 'crunch 1 5; exec bash'"
    xfce4-terminal --geometry=${TERM_WIDTH}x${TERM_HEIGHT}+0+540 --title="Bottom Terminal" &
    xfce4-terminal --geometry=${TERM_WIDTH}x${TERM_HEIGHT}+960+540 --title="Left Bottom Terminal" &
    # why 970 reduce -10 ??
    # why 85 reduce - 58 ??
	xdotool getactivewindow windowmove 960 27 windowsize 817 443
	#clear
	#xdotool getactivewindow getwindowgeometry

#
# FIXME
# dont run this lines Geometry problem 
# --geometry=817x443   so big    max value is 180x42
#    xfce4-terminal --geometry=817x443+0+0 --title="Top Terminal" &
#    xfce4-terminal --geometry=817x443+0+540 --title="Bottom Terminal" &
#    xfce4-terminal --geometry=817x443+960+540 --title="Left Bottom Terminal" &
#	xdotool getactivewindow windowmove 969 85 windowsize 817 443


# FIXME moving problem
    # Open and move first terminal
#    xfce4-terminal & sleep 0.5  
#    xdotool search --onlyvisible --class "xfce4-terminal" | tail -n 1 | xargs -I {} xdotool windowmove {} 59 85 windowsize {} 817 443 
#
#    # Open and move second terminal
#    xfce4-terminal & sleep 0.5  
#    xdotool search --onlyvisible --class "xfce4-terminal" | tail -n 1 | xargs -I {} xdotool windowmove {} 59 598 windowsize {} 817 443 
#
#    # Open and move third terminal
#    xfce4-terminal & sleep 0.5  
#    xdotool search --onlyvisible --class "xfce4-terminal" | tail -n 1 | xargs -I {} xdotool windowmove {} 969 85 windowsize {} 817 443  
#
#    # Move the currently active terminal
#    sleep 0.5
#    xdotool getactivewindow windowmove 969 598 windowsize 817 443

}

# Debug help
# Todo Fixme mathematical calculations 
#alias tel='xdotool getactivewindow getwindowgeometry'
# Position: 59,85 Geometry: 817x443 Left_top
# Position: 59,598 Geometry: 817x443 Left_bottom
# Position: 969,85 Geometry: 817x443 Right_top
# Position: 969,598 Geometry: 817x443 Right_bottom

alias need4='open_terminals_left_2'


# apache2 and renderd
restartall() {
    sudo systemctl restart renderd apache2
    #sudo systemctl status renderd
    #sudo systemctl status apache2
    clear
}


stopall() {
    sudo systemctl stop renderd
    sudo systemctl stop apache2
    clear
}
startall() {
    sudo systemctl start renderd
    sudo systemctl start apache2
    clear
}

alias ap2s='sudo systemctl status apache2'
alias rds='sudo systemctl status renderd'


#alias render_config='sudo subl /etc/renderd.conf'
password_set="0x7B"
alias render_config='echo $((password_set)) | sudo -S subl /etc/renderd.conf'
alias apache2_config='echo $((password_set)) | sudo -S subl /etc/apache2/sites-available/renderd-example-map.conf'


map_test() {
    #sudo systemctl restart renderd apache2
    sudo rm -rf /var/cache/renderd/tiles/*
    echo "tiles are removed sucessfuilly"
    sudo chown cnc:cnc /usr/share/renderd/example-map/*
    sudo chown -R cnc:cnc /usr/share/renderd/example-map/
    echo "permissin are changed suceffuly"
    sudo rm -f /run/renderd/renderd.sock
    echo "removed the old sock file"
    sudo chown -R renderd:renderd /run/renderd
    sudo chmod 755 /run/renderd
    echo "renderd sock permissin are changed suceffuly"
    sudo systemctl restart renderd
    echo "apache2 and renderd restard suceffuly"
    clear
}




# add library temp
export CPLUS_INCLUDE_PATH=$HOME/Desktop/BUILD_FILES/boost_1_83_0
export LIBRARY_PATH=$HOME/Desktop/BUILD_FILES/boost_1_83_0/stage/lib
export LD_LIBRARY_PATH=$HOME/Desktop/BUILD_FILES/boost_1_83_0/stage/lib:$LD_LIBRARY_PATH