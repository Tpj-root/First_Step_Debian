#!/bin/bash
#
# bug in gitclone
# mygit FIXME
#
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



# To check your Debian version:
# tellme_whoami
#
#
#
# lsb_release -a

function tellme_whoami() {
    echo "-------------------------------------------"

    cat /etc/os-release

    echo "-------------------------------------------"


    # echo `uname -a`
    # printf "%s\n" "$(uname -a)"

    info=$(uname -a)
    echo $info

    echo "-------------------------------------------"

}


check_kernel_info() {
    echo "🔍 Checking full kernel info using uname -a:"
    echo "-------------------------------------------"
    uname -a
    echo

    echo "📦 Extracting only the kernel version (uname -r):"
    echo "-------------------------------------------------"
    uname -r
    echo

    echo "📄 Reading kernel version from /proc/version:"
    echo "--------------------------------------------"
    cat /proc/version
    echo

    echo "🔧 Checking if PREEMPT_RT is enabled in kernel config:"
    echo "------------------------------------------------------"
    # This checks for real-time preemption configuration
    if [ -f /boot/config-$(uname -r) ]; then
        grep PREEMPT /boot/config-$(uname -r)
    elif [ -f /proc/config.gz ]; then
        zcat /proc/config.gz | grep PREEMPT
    else
        echo "Kernel config not found at expected locations."
    fi
    echo

    echo "📜 Checking dmesg logs for preempt messages:"
    echo "-------------------------------------------"
    dmesg | grep -i preempt | head -n 10
    echo

    echo "🖥️ Optional: Using hostnamectl to show kernel line:"
    echo "--------------------------------------------------"
    hostnamectl | grep Kernel
}


#
# Tune Hardware Clock Source
#
#
# Check available timers:
# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
#

##  cnc@debian:~$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
##  tsc hpet acpi_pm 





## ✅ Your system supports 3 clock sources:
## 
## ```
## tsc     → Time Stamp Counter (fastest, CPU-based)
## hpet    → High Precision Event Timer (stable, good for RT)
## acpi_pm → Power Management timer (slowest, fallback)
## ```
## 
## ### 🔍 To see which one is currently in use:
## 
## ```bash
## cat /sys/devices/system/clocksource/clocksource0/current_clocksource
## ```
## 
## ### ⚙️ To switch to `hpet` (often better for real-time):
## 
## ```bash
## echo hpet | sudo tee /sys/devices/system/clocksource/clocksource0/current_clocksource
## ```
## 
## > Use `hpet` if you're doing CNC work and want better timing stability.
## > Use `tsc` if you want maximum speed (but less stable on multi-core/variable CPU).
## 




##   ✅ Your system is currently using: `**tsc**` (Time Stamp Counter)
##   
##   ### ℹ️ What it means:
##   
##   * **Fastest** clock source (very low overhead)
##   * **Good for performance**, but…
##   * Can be **less stable** on multi-core CPUs, power-saving CPUs, or under thermal throttling
##   * Not ideal for **precise real-time CNC timing**
##   
##   ---
##   
##   ### 🔧 Recommended for CNC:
##   
##   Switch to **`hpet`** (High Precision Event Timer), more stable and accurate.
##   
##   ### 🔁 Switch to `hpet` (temporary until reboot):
##   
##   ```bash
##   echo hpet | sudo tee /sys/devices/system/clocksource/clocksource0/current_clocksource
##   ```
##   
##   ### 🔁 Make it permanent (GRUB):
##   
##   1. Edit GRUB:
##   
##   ```bash
##   sudo nano /etc/default/grub
##   ```
##   
##   2. Add to `GRUB_CMDLINE_LINUX_DEFAULT`:
##   
##   ```text
##   clocksource=hpet
##   ```
##   
##   3. Update GRUB:
##   
##   ```bash
##   sudo update-grub
##   ```
##   
##   4. Reboot:
##   
##   ```bash
##   sudo reboot
##   ```
##   
##   Then confirm again:
##   
##   ```bash
##   cat /sys/devices/system/clocksource/clocksource0/current_clocksource
##   ```
## 

## 
## 
## 
## 
## ---
## 
## ### 🔧 **Run HPET (manually):**
## 
## ```bash
## echo hpet | sudo tee /sys/devices/system/clocksource/clocksource0/current_clocksource
## ```
## 
## > This changes the clock source to HPET **immediately** (but not permanent).
## 
## ---
## 
## ### 📌 **RT Kernel vs HPET**
## 
## * `**HPET**` = **hardware timer**, helps with **precise timekeeping**
## * `**RT kernel**` = changes how the **Linux scheduler behaves**
## 
##   * **Gives real-time priority**, predictable latency
## 
## ---
## 
## ### ✅ Summary:
## 
## | Feature       | HPET           | RT Kernel             |
## | ------------- | -------------- | --------------------- |
## | Role          | Timer hardware | Kernel scheduler      |
## | Boost latency | ✅ Yes (some)   | ✅✅ Yes (full control) |
## | CNC friendly  | ✅              | ✅✅ (best)             |
## | Needed for RT | Often used     | Required for full RT  |
## 
## 👉 **Best setup for CNC**:
## **RT Kernel + HPET clocksource**
## 
## Want help installing RT kernel on Debian?






###    **simple and clear rule set** to help you write your own Bash functions — **cleanly, reusable, and understandable**.
###    
###    ---
###    
###    ## 🧱 Simple Rules to Write Your Own Bash Function
###    
###    ---
###    
###    ### 🔹 `rule_0` — **Explain the Usage**
###    
###    * Always include a help/usage block at the top using:
###    
###      ```bash
###      if [[ "$1" == "--help" || $# -ne <expected_count> ]]; then
###          echo "Usage: ..."
###          return
###      fi
###      ```
###    
###    ---
###    
###    ### 🔹 `rule_1` — **Start with a clear name**
###    
###    * Use `snake_case` for readability
###      ✅ Good: `list_by_extension`
###      ❌ Bad: `LSTX` or `doItFast`
###    
###    ---
###    
###    ### 🔹 `rule_2` — **Use meaningful parameter names**
###    
###    * Inside the function, store `$1`, `$2`, etc. into named variables
###    
###      ```bash
###      ext="$1"
###      ```
###    
###    ---
###    
###    ### 🔹 `rule_3` — **Use comments to explain**
###    
###    * Add inline comments for each logic step
###    
###    ---
###    
###    ### 🔹 `rule_4` — **Always validate input**
###    
###    * Check for empty or invalid input and show friendly error/help
###    
###    ---
###    
###    ### 🔹 `rule_5` — **Be safe with file operations**
###    
###    * Use `"quotes"` for all variables to avoid bugs with spaces
###    
###      ```bash
###      mv "$file" "$target_dir/"
###      ```
###    
###    ---
###    
###    ### 🔹 `rule_6` — **Support `--help` always**
###    
###    * Make every function self-explaining when called with `--help`
###    
###    ---
###    
###    ### 🔹 `rule_7` — **Keep logic readable**
###    
###    * Split into steps with line breaks
###    * Group related logic
###    
###    ---
###    
###    ### 🧪 Example Template Applying All Rules
###    
###    ```bash
###    my_function() {
###      # ✅ rule_0: Show usage if wrong input
###      if [[ "$1" == "--help" || $# -ne 1 ]]; then
###        echo "Usage: my_function <name>"
###        echo "Greets the user by name"
###        return
###      fi
###    
###      # ✅ rule_2: Store parameter
###      name="$1"
###    
###      # ✅ rule_3: Add clear comment
###      # Print a greeting message
###      echo "Hello, $name!"
###    }
###    ```
###    
###    ---
###    
###    ### ✅ Summary Table
###    
###    | Rule    | Purpose                 | Tip                            |
###    | ------- | ----------------------- | ------------------------------ |
###    | rule\_0 | Add usage/help section  | Use `--help` or argument count |
###    | rule\_1 | Use clean names         | snake\_case                    |
###    | rule\_2 | Name your inputs        | `input="$1"`                   |
###    | rule\_3 | Comment logic           | Explain each step              |
###    | rule\_4 | Validate inputs         | Check args, file exists, etc.  |
###    | rule\_5 | Quote all variables     | `"${var}"`                     |
###    | rule\_6 | Always support `--help` | Users can self-learn           |
###    | rule\_7 | Keep logic readable     | Separate into steps            |
###    
###    ---
###    



### rules_bash = [
###     ("rule_0 - Explain the Usage",
###      "Always include a help/usage block.\nExample:\n  if [[ \"$1\" == \"--help\" || $# -ne <expected> ]]; then\n      echo \"Usage: ...\"\n      return\n  fi"),
### 
###     ("rule_1 - Use Clear Function Names",
###      "Use snake_case for better readability.\nGood: list_by_extension\nBad: FUNC1 or lstx"),
### 
###     ("rule_2 - Use Meaningful Parameter Names",
###      "Store $1, $2... into readable variables.\nExample:\n  filename=\"$1\""),
### 
###     ("rule_3 - Comment Your Logic",
###      "Add inline comments explaining each step of your function."),
### 
###     ("rule_4 - Validate Inputs",
###      "Check if required arguments are passed or if a file exists.\nUse friendly error messages."),
### 
###     ("rule_5 - Use Safe Quoting",
###      "Wrap variables in double quotes to handle spaces safely.\nExample:\n  mv \"$file\" \"$target_dir/\""),
### 
###     ("rule_6 - Always Support --help",
###      "Let the user call the function with --help to understand how to use it."),
### 
###     ("rule_7 - Keep It Readable",
###      "Use spacing, line breaks, and group logic steps for clean structure.")
### ]
### 




##################################
#          START
##################################

version="1.0"
#echo "Script Name: ${BASH_SOURCE[0]}"

alias date="date '+%d-%m-%Y %H:%M:%S' | tr ' ' '_'"

## Enabled for only one time for insatinng basicsoftwares
## Enabled or Disable
SoftWare_Installing=0  # 1 means enabled, 0 means disabled
Jocker_Installing=0 # 1 means enabled, 0 means disabled
###
Title_screen=0 # 1 means enabled, 0 means disabled
Prompt_Animation=0

# FIND DIFF
# echo -e "\u2500"
# printf "\u2500\n"
# If your terminal supports UTF-8, it will display the box-drawing character correctly.


# Method 1: Unicode Escape Sequence
# echo -e "\u2500"
# Method 2: Hexadecimal UTF-8 Encoding
# echo -e "\xe2\x94\x80"
# Method 3: Using printf
# printf "\u2500\n"

# ────────────────────
# --------------------
# _____________________
# ......................
# **********************
# ``````````````````````
#+++++++++++++++++++++++
#

#########################
#
# 📄 Function Template With Usage Example
#
#########################

usage_function() {
    # ✅ Usage info (shown when called with --help or wrong usage)
    if [[ "$1" == "--help" || "$#" -ne 1 ]]; then
        echo "Usage: my_function <filename>"
        echo
        echo "This function checks if the given file exists."
        echo
        echo "Arguments:"
        echo "  <filename>   Path to the file to check"
        echo
        echo "Example:"
        echo "  my_function myfile.txt"
        return
    fi

    # Actual function logic
    file="$1"
    if [[ -f "$file" ]]; then
        echo "✅ File exists: $file"
    else
        echo "❌ File not found: $file"
    fi
}



# Define color codes
#
#  color list
#
# Define colors function
function get_colors() {
    RESET='\033[0m'
    BLACK='\033[30m'
    RED='\033[31m'
    GREEN='\033[32m'
    #The 1; makes it bold/bright, which should look more vivid.
    YELLOW='\033[1;33m'
    # Some terminals render it as a darker yellow, which might appear brownish.
    #YELLOW='\033[33m'
    BLUE='\033[34m'
    MAGENTA='\033[35m'
    CYAN='\033[36m'
    WHITE='\033[37m'
    BOLD='\033[1m'
    UNDERLINE='\033[4m'
    GRAY='\033[90m'
    BRIGHT_RED='\033[91m'
    BRIGHT_GREEN='\033[92m'
    BRIGHT_YELLOW='\033[93m'
    BRIGHT_BLUE='\033[94m'
    BRIGHT_MAGENTA='\033[95m'
    BRIGHT_CYAN='\033[96m'
    BRIGHT_WHITE='\033[97m'
    BLINK='\033[5m'
}

# Call the function to define colors
get_colors




# Store all colors in an array
colors=("$RESET" "$BLACK" "$RED" "$GREEN" "$YELLOW" "$BLUE" "$MAGENTA" "$CYAN" "$WHITE" \
        "$BOLD" "$UNDERLINE" "$BRIGHT_BLACK" "$GRAY" "$BRIGHT_RED" "$BRIGHT_GREEN" "$BRIGHT_YELLOW" \
        "$BRIGHT_BLUE" "$BRIGHT_MAGENTA" "$BRIGHT_CYAN" "$BRIGHT_WHITE")


function Test_All_The_colurs()
{
    # Test - Print all colors
    for color in "${colors[@]}"; do
        echo -e "${color}This is a test message${RESET}"
    done
    
}

#Test_All_The_colurs
#sleep 10

#SoftWare_Installing_func()
#{
#    if ! command -v figlet &> /dev/null; then
#        echo "figlet is not installed. Installing figlet..."
#        sudo apt install -y figlet
#        if ! command -v figlet &> /dev/null; then
#            echo "Failed to install figlet. Please install it manually and try again."
#            exit 1
#        fi
#    fi
#}
#


function print_random_color() {
    local message=$1
    local random_color=${colors[$RANDOM % ${#colors[@]}]}
    echo -e "${random_color}${message}${RESET}"
}

function print_special_color() {
    local message=$1
    local random_color=${BLUE}
    echo -e "${random_color}${message}${RESET}"
}

#print_random_color HELLO
#print_special_color HELLOO

# TEst
#
# echo -e "${GREEN}This is green text.${RESET}"
# echo -e "${RED}This is red text.${RESET}"
# echo -e "${BLUE}This is blue text.${RESET}"
# echo -e "${YELLOW}${BOLD}This is bold yellow text.${RESET}"
# echo -e "${MAGENTA}${UNDERLINE}This is underlined magenta text.${RESET}"


function test_yellow()
{
	echo -e "${YELLOW}This is yellow text.${RESET}"

}




function title_fun() {

print_special_color " .d8888. db   db  .d8b.  d8888b.  .d88b.  db   d8b   db " 
print_special_color " 88'  YP 88   88 d8' \`8b 88  \`8D .8P  Y8. 88   I8I   88 " 
print_special_color " \`8bo.   88ooo88 88ooo88 88   88 88    88 88   I8I   88 " 
print_special_color "   \`Y8b. 88~~~88 88~~~88 88   88 88    88 Y8   I8I   88 " 
print_special_color " db   8D 88   88 88   88 88  .8D \`8b  d8' \`8b d8'8b d8' " 
print_special_color " \`8888Y' YP   YP YP   YP Y8888D'  \`Y88P'   \`8b8' \`8d8'  " 
print_special_color "                          bash ${version}    "
}


function why() {
echo -e ${GREEN} "The journey of a thousand miles begins with a single step."
echo -e ${GREEN} "The reason to start is to open the door to the possibilities that lie ahead."
}



# Function to check the condition SoftWare_Installing 
function check_the_condition_Title_screen() {
    if [[ "$Title_screen" -eq 1 ]]; then
        # Run the function for selected categories
		title_fun
		why
    fi
}

check_the_condition_Title_screen

# 
# Function to check the condition Animation prompt
function check_the_condition_Animation() {
    if [[ "$Prompt_Animation" -eq 1 ]]; then
        # Run the function for selected categories

		function spinner1() {
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

		function spinner() {
		    local chars=("👽" "💀" "🐺" "👻")
		    echo -n "${chars[$((SECONDS % ${#chars[@]}))]}"
		}

		export PS1="${GRAY}${BLINK}🅂 🅷 🅰 🅳 🅾 🆆 ${RESET} @ bash $(spinner) 🡆 "
		#export PS1='🅂 🅷 🅰 🅳 🅾 🆆 @ bash $(spinner) 🡆 '

		function print_colors() {
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


##########
# replace spaces with underscores in all filenames in the current directory
# remove special characters from filenames
function clean_filenames() {
  for file in *; do
    new_name=$(echo "$file" | tr ' ' '_' | tr -d '(){}\-~!@#$%^&*()+|')
    [ "$file" != "$new_name" ] && mv "$file" "$new_name"
  done
}



#alias edit='gedit $HOME/.bashrc'
#alias edit='subl $HOME/.bashrc'
#alias edit='nano $HOME/.bashrc'

# Function to set the 'edit' alias based on available text editors
function set_edit_alias() {
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

alias myedit2='subl $HOME/.bashrc'


# daily notes 
#alias study='gedit $HOME/Desktop/IM_FILES/study.all'


##################################
# A good way to share bug details
#  seq 1 100 | paste-online 
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
### xdotool
### autotype
function hw1() {
    clear
    sleep 0.5
    xdotool key ctrl+l  # Alternative to clear screen
    #xdotool key Return  # Ensure a new line
    sleep 0.2
    xdotool type "Hello World"
    #xdotool key Return  # Press Enter after typing
}



function scam_alert_1000() {
    sleep 5
    for i in {1..1000}; do
        xdotool type "scam alert!"
        xdotool key Return
        sleep 0.2
    done
}


function scam_alert_500() {
    sleep 5
    for i in {1..500}; do
        xdotool type "scam alert!"
        xdotool key Return
        sleep 0.2
    done
}

function scam_alert_10() {
    sleep 5
    for i in {1..10}; do
        xdotool type "scam alert!"
        xdotool key Return
        sleep 0.2
    done
}




function priya10() {
    sleep 5
    for i in {1..10}; do
        xdotool type "hello priya!"
        xdotool key Return
        sleep 0.2
    done
}





##################
#
# Software list
# sudo apt install unrar-free
# unrar-free x BOOKS.rar
# A fast, highly customizable system info script
# sudo apt install neofetch


mystl()
{
    if ! command -v fstl &> /dev/null; then
        echo "fstl is not installed. Installing fstl..."
        sudo apt install -y fstl
        if ! command -v fstl &> /dev/null; then
            echo "Failed to install fstl. Please install it manually and try again."
            exit 1
        fi
    fi

    fstl $1
}


myscreencast()
{
    if ! command -v vokoscreenNG &> /dev/null; then
        echo "vokoscreenNG is not installed. Installing vokoscreenNG..."
        sudo apt install -y vokoscreen-ng
        if ! command -v fstl &> /dev/null; then
            echo "Failed to install vokoscreenNG. Please install it manually and try again."
            exit 1
        fi
    fi
    vokoscreenNG
}





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
function extract() {
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
function mtouch() {
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
# project folder analyzing
function header_files_list()
{
    # Find all .c and .cpp files in the current directory and subdirectories
    find . -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \) | while read -r file; do
        echo "Processing: $file"
        # Extract and print unique header includes
        grep -E "^#include <.*>" "$file" | awk '!seen[$0]++'
    done
}

alias h_list='header_files_list | sort -n | uniq | grep -i "#include"'
alias h_list_out='header_files_list | sort -n | uniq | grep -i "#include" >h_list_out.txt'





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
function download_gif() {
    # Generate a random filename with 8 characters (alphanumeric)
    filename=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8).gif

    # Download the GIF using curl
    curl -o "$filename" "$1"

    # Output the filename for confirmation
    echo "Downloaded as $filename"
}





################
# OLD
#Backup_function
################
function bashrc_backup() {
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
function oc() {
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

kill_port() {
  port=${1:-8000}
  pid=$(lsof -ti tcp:$port)
  if [ -n "$pid" ]; then
    echo "Killing process on port $port (PID: $pid)"
    kill -9 $pid
  else
    echo "No process found on port $port"
  fi
}






# Bash function to modify /etc/resolv.conf and replace its content with the given nameservers
function modify_resolv_conf_0() {
    sudo bash -c 'cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 2001:4490:3ffe:13::4
nameserver 2001:4490:3ffe:13::c
EOF'
    echo "Updated /etc/resolv.conf successfully."
}

function modify_resolv_conf_1() {
    sudo bash -c 'cat > /etc/resolv.conf <<EOF
nameserver 1.1.1.1
nameserver 1.0.0.1
EOF'
    echo "Updated /etc/resolv.conf successfully."
}

function modify_resolv_conf_2() {
    sudo bash -c 'cat > /etc/resolv.conf <<EOF
nameserver 208.67.222.222
nameserver 208.67.220.220
EOF'
    echo "Updated /etc/resolv.conf successfully."
}

function modify_resolv_conf_3() {
    sudo bash -c 'cat > /etc/resolv.conf <<EOF
nameserver 218.248.112.225
nameserver 218.248.112.193
EOF'
    echo "Updated /etc/resolv.conf successfully."
}








alias dnsupdate_Google='modify_resolv_conf_0'
alias dnsupdate_Cloudflare='modify_resolv_conf_1'
alias dnsupdate_OpenDNS='modify_resolv_conf_2'
alias dnsupdate_BSNL='modify_resolv_conf_3'



# If you want to modify /etc/resolv.conf while keeping the old lines as a backup, use this function
#modify_resolv_conf() {
#    sudo cp /etc/resolv.conf /etc/resolv.conf.bak  # Backup old file
#    echo "Backup created at /etc/resolv.conf.bak"
#
#    sudo bash -c 'cat > /etc/resolv.conf <<EOF
#nameserver 8.8.8.8
#nameserver 8.8.4.4
#nameserver 2001:4490:3ffe:13::4
#nameserver 2001:4490:3ffe:13::c
#EOF'
#    echo "Updated /etc/resolv.conf successfully."
#}


########## 
## KDE CONNECT
## 
#########
# FIX BUG 
# IP 
# sudo apt install kdeconnect ufw










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
## python3_server
## 
#########
# uploads
#
#





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
alias pyenv='miniconda_activate'
function check_new_packages() {
    comm -13 <(sort $HOME/Desktop/MY_GIT/First_Step_Debian/installed_packages.txt) <(pip list | sort)
}
alias mini_check='check_new_packages'

############
#### LATEX
############

alias tex='pdflatex'




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


function mvcomp() {
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


function print_emoji() {
    local code=$1
    printf "\U$(printf "%08x" "$code")" "$code"
}

# Example usage: # U+2705: ✅
function GreenTick() {
    print_emoji 0x2705
}

# U+274C: ❌
function RedTick() {
    print_emoji 0x274C
}

# U+1F47D: 👽
function Alien() {
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
#### git_study
############
# If You Want to Keep Both Local & Remote Changes
# git pull --no-rebase
# git commit -m "Merge remote changes"
# git push





############
#### git
############
#
alias gitwhois='git remote -v'

#alias gitc='git clone'
#alias gitc='git clone'
# Function: gitc
# Description: This function clones a Git repository into a predefined directory ($HOME/Desktop/MY_GIT).
# Usage: gitc <repository_url>
# - If the target directory does not exist, it is created.
# - If no URL is provided, an error message is displayed.

function G_itclone() {
    GIT_DIR="$HOME/Desktop/MY_GIT"
    
    # Ensure the directory exists
    if [ ! -d "$GIT_DIR" ]; then
        echo "Creating directory: $GIT_DIR"
        mkdir -p "$GIT_DIR"
    fi
    
    # Change to the target directory
    cd "$GIT_DIR" || { echo "Error: Failed to change directory to $GIT_DIR"; return 1; }

    # Check if a repository URL is provided
    if [[ -z "$1" ]]; then
        echo "Usage: gitc <repository_url>"
        echo "Error: No repository URL provided."
        return 1
    fi
    
    # Clone the repository
    echo "Cloning repository: $1"
    git clone "$1"
}


# git_help
alias gits='git status'
alias gitlog='git log'
alias gitd='git diff'
alias gg='gitgo'
alias gitsubmoduledownload='git submodule update --init --recursive'
alias gitwho='git remote get-url origin'
alias gitrestore='git restore -- .'
alias gitundo='git reset'


# Status of git rep
# 
#
function gitcheck() 
{

# Change to the main directory
cd $HOME/Desktop/MY_GIT || exit

# Flag to track if any changes are detected
changes_detected=false

# Loop through each folder in the directory
for folder in */; do
    # Navigate to the folder
    cd "$folder" || continue

    # Check git status and capture the output
    status=$(git status --porcelain)

    # If there are any changes, print the folder name in red
    if [[ -n "$status" ]]; then
        echo -e "Changes detected in folder: \033[31m$folder\033[0m"
        changes_detected=true
    fi

    # Go back to the main directory
    cd ..
done

# If no changes were detected, print the green message
if ! $changes_detected; then
    echo -e "\033[32mThere is no change where there is no action.\033[0m"
fi

}



function git_tag_help() {
    echo "🔖 Existing tags:"
    git tag

    echo
    echo
    read -p "Enter new git tag version (e.g., v1.0): " tag_version
    echo "Version 1.0: motion plotting complete"
    read -p "Enter tag message: " tag_message

    echo
    echo "Creating annotated tag..."
    git tag -a "$tag_version" -m "$tag_message"

    echo
    echo "✅ Tag created. Current tags:"
    git tag

    echo
    echo "Pushing tags to remote..."
    git push origin --tags

    echo "🚀 Done!"
}






template_gitignore() {
cat <<EOL > .gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*.so

# Virtual environment
venv/
env/

# IDE files
.vscode/
*.swp

# OS files
.DS_Store
Thumbs.db
EOL

echo ".gitignore created."
}

# Call the function
#template_gitignore





#
# This will check if the key is added. If not,
# it will prompt for a passphrase.
#  you can install ssh-askpass
# For X11-based systems (GUI)
# sudo apt install ssh-askpass
# For GTK-based systems (GNOME)
# sudo apt install ssh-askpass-gnome
# For Qt-based systems (KDE)
# sudo apt install ssh-askpass-fullscreen
#
function check_and_install_ssh_askpass() {
    if ! dpkg -l | grep -q ssh-askpass; then
    	# does not produce any output because `-q` (quiet) suppresses output. 
		# It only sets the exit status:  
		# - Exit status 0 → `ssh-askpass` is installed.  
		# - Exit status 1 → `ssh-askpass` is not installed.  

        echo "ssh-askpass is not installed. Installing..."
        sudo apt install -y ssh-askpass
    else
        echo "ssh-askpass is already installed."
    fi
}

#check_and_install_ssh_askpass


alias gitaddkey='ssh-add $HOME/Desktop/IM_FILES/id_rsa'
# Function to check and add the SSH private key if not already added
function check_ssh_key() {
    # Define the path to the SSH private key
    SSH_KEY="$HOME/Desktop/IM_FILES/id_rsa"
    # check
    check_and_install_ssh_askpass

    # Check if the SSH key is already added to the SSH agent
    if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$SSH_KEY" | awk '{print $2}')"; then
        # If the key is not found, prompt the user to enter the passphrase
        echo "SSH key not added. Enter passphrase to add it:"
        # Add the SSH key to the agent, which will require the user to enter the passphrase
        #ssh-add "$SSH_KEY"
        # the GUI password prompt appears
        # because ssh-add detects an empty passphrase
        # input and falls back to using a GUI authentication agent (like ssh-askpass).
        echo ""| gitaddkey

        # Force terminal-based input
        # ssh-add < /dev/tty
        # silent passphrase entry (without echoing characters)
        # read -s -p "Enter passphrase: " passphrase && echo "$passphrase" | ssh-add $HOME/Desktop/IM_FILES/id_rsa


    fi
}

# Ensure the function runs only in an interactive shell
# This prevents execution in non-interactive scripts or background processes
# https://github.com/Tpj-root/Bash_Scripting/blob/main/bash/Interactive_session.txt
if [[ $- == *i* ]]; then
    check_ssh_key  # Call the function to check and add the SSH key
fi



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

    cd $HOME/Desktop/MY_GIT
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
#     trackers start
#
##########################################
#
# https://github.com/ngosang/trackerslist/tree/master

function giturl_convert_to_raw() {
    local url="$1"
    echo "$url" | sed -E 's|https://github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)|https://raw.githubusercontent.com/\1/\2/\3/\4|'
}

# Example usage
#convert_to_raw "https://github.com/ngosang/trackerslist/blob/master/trackers_all.txt"


#copy_raw_to_clipboard() {
#    local url="$1"
#    curl -s "$url" | xclip -selection clipboard
#}
#
## Example usage
#copy_raw_to_clipboard "https://raw.githubusercontent.com/ngosang/trackerslist/refs/heads/master/trackers_all.txt"


function trackerscopy() {
    local url="$1"
    curl -s "https://raw.githubusercontent.com/ngosang/trackerslist/refs/heads/master/trackers_all.txt" | xclip -selection clipboard
    echo "Now ready to paste wherever you want."
}

# Example usage
#copy_raw_to_clipboard "https://raw.githubusercontent.com/ngosang/trackerslist/refs/heads/master/trackers_all.txt"

##########################################
#     trackers end
#
##########################################
##########################################
#     jocker start
#
##########################################
function check_and_install_jocker() {
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
function check_the_condition_jocker() {
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

function check_and_setup_apache() {
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
#check_and_setup_apache
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





#---------------------------------------------------
# Function: colored_yes_no
# Description: Returns a formatted string displaying 
#              "yes" in green and "no" in red, 
#              wrapped in parentheses.
# Usage Example:
#   echo -e "Do you want to continue? $(colored_yes_no): "
#---------------------------------------------------
function colored_yes_no() {
    echo -e "(${GREEN}yes${RESET}/${RED}no${RESET})"
}


# This scheme follows standard UI/UX conventions, making it easy to understand at a glance. 
#| **Function Name**   | **Color**  | **Purpose**                                      |
#|---------------------|-----------|--------------------------------------------------|
#| `warning_message`   | 🔴 Red     | Critical warnings, alerts, errors               |
#| `status_message`    | 🟡 Yellow  | Informational messages, ongoing processes       |
#| `active_message`    | 🟢 Green   | Success, completion, active status              |
#| `error_message`     | 🚨 Bright Red | Serious errors, immediate action needed    |
#| `info_message`      | 🔵 Blue    | General information, guidance, tips             |
#| `debug_message`     | 🟣 Magenta | Debugging logs, internal checks                 |
#| `success_message`   | ✅ Bright Green | Positive feedback, confirmations         |
#| `notice_message`    | 🔶 Cyan    | Minor notifications, soft alerts                |


#---------------------------------------------------
# Function: warning_message
# Description: Displays a warning message in a table-style 
#              format, dynamically adjusting the width.
# Parameters:
#   $1 - Custom warning message (centered)
# Usage Example:
#   warning_message "This action cannot be undone!"
#---------------------------------------------------
warning_message() {
    local msg="$1"
    local msg_length=${#msg}
    local box_width=$((msg_length + 4))  # Add 2 spaces on each side

#    # Print top border
#    echo -e "🔴${RED}$(printf '=%.0s' $(seq $box_width))🔴"
#
#    # Print centered message
#    printf "| %s |\n" "$msg"
#
#    # Print bottom border
#    echo -e "$(printf '=%.0s' $(seq $box_width))${RESET}"


    echo -e "${RED}"
    printf "🔴 : %s \n" "$msg"
    echo -e "${RESET}"
}


# warning_message " WARNING: This function will modify and delete files."


status_message() {
    local msg="$1"
    local msg_length=${#msg}
    local box_width=$((msg_length + 4))  # Add 2 spaces on each side

    # Print top border
    #echo -e "${YELLOW}$(printf '=%.0s' $(seq $box_width))"

    # Print centered message
    # printf "🟡 : | %s |\n" "$msg"
    echo -e "${YELLOW}"
    printf "🟡 : %s \n" "$msg"
    echo -e "${RESET}"
    # Print bottom border
    #echo -e "$(printf '=%.0s' $(seq $box_width))${RESET}"
}


# status_message " STATUS: This STATUS message."

active_message() {
    local msg="$1"
    local msg_length=${#msg}
    local box_width=$((msg_length + 4))  # Add 2 spaces on each side

#    # Print top border
#    echo -e "${GREEN}$(printf '=%.0s' $(seq $box_width))"
#
#    # Print centered message
#    printf "🟢 : | %s |\n" "$msg"
#
#    # Print bottom border
#    echo -e "$(printf '=%.0s' $(seq $box_width))${RESET}"
#

    echo -e "${GREEN}"
    printf "🟢 : %s \n" "$msg"
    echo -e "${RESET}"





}

#active_message
# active_message " ACTIVE: This active_message ."


#
#
#Turn on 2-Step Verification
#
#---------------------------------------------------
# Function: twoStepVerification
# Description: Asks the user twice for confirmation before executing.
#              If confirmed, it runs a test sequence (seq 1 10).
#              If the user aborts, it exits without executing.
#---------------------------------------------------

function twoStepVerification() {
    # Create Fucntion
    # echo -e "${RED}====================================================="
    # echo "  WARNING: This function will modify and delete files."
    # echo -e "=====================================================${RESET}"
    
    warning_message " WARNING: This function will modify and delete files."

    # First confirmation prompt
    echo -e "Do you really want to continue?  $(colored_yes_no): "
    read -r choice1
    if [[ ! "$choice1" =~ ^(yes|y|YES|Y)$ ]]; then
        echo "Aborted."
        return 1  # Return 1 to indicate failure
    fi

    # Second confirmation prompt for extra security
    read -p "Are you absolutely sure?  $(colored_yes_no): " choice2
    if [[ "$choice2" != "yes" ]]; then
        echo "Aborted."
        return 1  # Return 1 to indicate failure
    fi

    # If both confirmations are passed, proceed with execution
    echo "Executing the operation..."
    #seq 1 10  # Example operation
    echo "Operation completed successfully."
    return 0  # Return 0 to indicate success
}

#---------------------------------------------------
# Function: seq10
# Description: Calls twoStepVerification. If the user 
#              confirms twice, it executes seq 1 10. 
#              Otherwise, it exits without running.
#---------------------------------------------------
function seq10() {
    # Call twoStepVerification and check if it was aborted
    twoStepVerification || return  # If aborted, exit the function

    # If confirmation passed, execute seq 1 10
    echo "Running additional sequence..."
    seq 1 10
}

# Example usage:
# Uncomment the line below to test
# seq10




#################################################
# 
# project2html
# 
# 
#################################################
function project2html(){

    twoStepVerification || return  # If aborted, exit the function

    # version 1.0
    # remove the other files
    # find . -type f ! \( -name "*.html" -o -name "*.css" \) -exec rm -v {} \;
    # Check if highlight is installed, if not, install it
    if ! command -v highlight &> /dev/null
    then
        echo "highlight not found, installing..."
        sudo apt update && sudo apt install highlight
    fi

    # Function to create an HTML file for the index
    function create_index() {
        local dir="$1"
        local index_file="$2"
        local back_link="$3"

        echo "<html>" > "$index_file"
        echo "<head>" >> "$index_file"
        echo "<title>Project Files</title>" >> "$index_file"
        echo "<style>" >> "$index_file"
        echo "body.hl { background-color: #e0eaee; }" >> "$index_file"
        echo "</style>" >> "$index_file"
        echo "</head>" >> "$index_file"
        echo "<body class='hl'>" >> "$index_file"
        
        if [[ -n "$back_link" ]]; then
            echo "<a href='$back_link'>Back</a><br>" >> "$index_file"
        fi

        echo "<h1>Project Files</h1>" >> "$index_file"
        echo "<ul>" >> "$index_file"
    }

    # Function to recursively process the directory and convert files
    function process_directory() {
        local dir="$1"
        local index_file="$2"
        local base_dir="$3"
        local parent_dir="$4"

        # Create the index.html for the current directory
        local back_link=""
        if [[ -n "$parent_dir" ]]; then
            # Create the relative path for the back button
            local parent_index_file="${parent_dir}/index.html"
            back_link=$(realpath --relative-to="$dir" "$parent_index_file")
        fi
        create_index "$dir" "$index_file" "$back_link"

        # Loop through all files and directories
        for file in "$dir"/*; do
            if [[ -d "$file" ]]; then
                # If it's a directory, recurse into it
                local dir_name=$(basename "$file")
                local sub_index_file="$file/index.html"
                echo "<li><a href='$dir_name/index.html'>$dir_name</a></li>" >> "$index_file"
                process_directory "$file" "$sub_index_file" "$base_dir" "$dir"
            elif [[ -f "$file" && ( "$file" == *.c || "$file" == *.cpp || "$file" == *.hpp || "$file" == *.hpp || "$file" == *.rst || "$file" == *.yml || "$file" == *.txt || "$file" == *.h || "$file" == *.in || "$file" == *.diagram || "$file" == *.cmake || "$file" == *.xml || "$file" == *.jam || "$file" == *.md || "$file" == *.dic || "$file" == *.cfg || "$file" == *.am || "$file" == *.yaml || "$file" == *.toml || "$file" == *.dot || "$file" == *.css || "$file" == *.aff || "$file" == *.py || "$file" == *.sh ) ]]; then
                # Convert supported files into HTML
                local ext="${file##*.}"
                local base_name=$(basename "$file" ."$ext")
                local output_file="${dir}/${base_name}_${ext}.html"
                
                # Highlight the file to generate HTML output
                highlight --force -O html -i "$file" -o "$output_file" 2>/dev/null

                # Calculate the relative path for the link
                local rel_path=$(realpath --relative-to="$dir" "$output_file")
                echo "<li><a href='$rel_path'>$(basename "$file")</a></li>" >> "$index_file"
            fi
        done

        # Close the HTML tags
        echo "</ul>" >> "$index_file"
        echo "</body></html>" >> "$index_file"
    }

    # Main directory to start processing
    start_dir="."
    base_dir=$(realpath "$start_dir")

    # Index file location
    index_file="index.html"

    # Process the directory and generate HTML links for each file
    process_directory "$start_dir" "$index_file" "$base_dir" ""

    echo "Project HTML structure has been generated. Open $index_file to view the result."
    # -i (interactive) asks for confirmation before deleting each file
    # -f (force) removes files without any prompt, even if they are write-protected.
    # -v (verbose) shows the names of deleted files.
    find . -type f ! \( -name "*.html" -o -name "*.css" \) -exec rm -fv {} \;
    echo "All non html and .css fils are removed"
}


# Execute the function
#project2html

# alias
alias p2html='project2html'




############
# Arduino
# https://github.com/arduino/arduino-cli/releases
# https://github.com/Tpj-root/Arduino_CLI
#
#
#alias ard='$HOME/Desktop/RUN_TIME/arduino-cli_1.1.1_Linux_64bit/arduino-cli'
#alias arduino-cli='ard'

function arduino-cli() {
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
# kicad appimage
# https://www.freecad.org/
# https://github.com/KiCad/kicad-docker/pkgs/container/kicad
# https://hub.docker.com/r/kicad/kicad
# https://github.com/CyberCircuits/kicad-appimage


# Function to check and run kicad AppImage
function mykicad() {
    # Define the URL
    #local url="https://github.com/FreeCAD/FreeCAD/releases/download/1.0.0/FreeCAD_1.0.0-conda-Linux-x86_64-py311.AppImage"
    # Extract the filename from the URL
    local version_app
    version_app=$(cd $HOME/Desktop/RUN_TIME/ && ls KiCad* 2>/dev/null)  # Avoid errors if no match


    # Define the file path
    local file="$HOME/Desktop/RUN_TIME/$version_app"
    local dir="$HOME/Desktop/RUN_TIME"

    # Ensure the directory exists
    mkdir -p "$dir"

    # Check if the file exists, download if not
    if [[ ! -f "$file" ]]; then
        echo "File not found. Downloading..."
        echo "Try to download manually"
        echo "https://github.com/KiCad/kicad-docker/pkgs/container/kicad"
        
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
#mykicad

alias kicad='$HOME/Desktop/RUN_TIME/KiCad-8.0.9.glibc2.29-x86_64.3d.AppImage'













################
# https://www.freecad.org/
# https://github.com/FreeCAD/FreeCAD/releases/tag/1.0.0


# Function to check and run freecad AppImage
function freecad() {
    # Define the URL
    local url="https://github.com/FreeCAD/FreeCAD/releases/download/1.0.0/FreeCAD_1.0.0-conda-Linux-x86_64-py311.AppImage"

    # Extract the filename from the URL
    local version_app="${url##*/}"

    # Define the file path
    local file="$HOME/Desktop/RUN_TIME/$version_app"
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
#freecad

# alias
alias 3d='freecad'




################
# https://librecad.org/
# https://github.com/LibreCAD/LibreCAD/releases
# https://github.com/LibreCAD/LibreCAD/releases/tag/2.2.1.1_rc-latest
# Wiki
# https://dokuwiki.librecad.org/doku.php/start
# Developing
# https://github.com/LibreCAD/LibreCAD/wiki/Git-and-GitHub

# Function to check and run librecad AppImage
function librecad() {
    # Define the URL
    local url="https://github.com/LibreCAD/LibreCAD/releases/download/2.2.1.1_rc-latest/LibreCAD-v2.2.1.1-9-g5ad9b999-x86_64.AppImage"

    # Extract the filename from the URL
    local version_app="${url##*/}"

    # Define the file path
    local file="$HOME/Desktop/RUN_TIME/$version_app"
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
#librecad

# alias
alias 2d='librecad'



################
# https://www.texstudio.org/#download
# https://github.com/texstudio-org/texstudio/

#TeXstudio
#texstudio
# Function to check and run TeXstudio AppImage
function texstudio() {
    # Define the URL
    local url="https://github.com/texstudio-org/texstudio/releases/download/4.8.6/texstudio-4.8.6-x86_64.AppImage"

    # Extract the filename from the URL
    local version_app="${url##*/}"

    # Define the file path
    local file="$HOME/Desktop/RUN_TIME/$version_app"
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
# 
# #alias you='$HOME/Desktop/RUN_TIME/YTDownloader_Linux.AppImage'
# Download_full_playlist
# https://github.com/aandrew-me/ytDownloader/releases
# make function if 

# Function to check and run YTDownloader_Linux.AppImage
function you() {
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

function myanydesk() {
    # Set variables
    local dir="$HOME/Desktop/RUN_TIME"
    local file="$dir/anydesk_6.4.2-1_amd64.deb"

    # 
    local url="https://download.anydesk.com/linux/anydesk_7.0.0-1_amd64.deb"
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

function imhex() {
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
#alias tele='cd $HOME/Desktop/RUN_TIME/Telegram && ./Telegram'
################
# 

function tele() {
    # Define the file path and directory
    local dir="$HOME/Desktop/RUN_TIME/Telegram"
    local file="$dir/Telegram"
    local url="https://td.telegram.org/tlinux/tsetup.5.12.3.tar.xz"
    local archive="$dir/tsetup.tar.xz"

    # Ensure the directory exists
    mkdir -p "$dir"

    # Check if the Telegram binary exists
    if [[ ! -f "$file" ]]; then
        echo "File not found. Downloading..."
        wget -O "$archive" "$url" || { echo "Download failed!"; return 1; }

        # Extract the archive
        echo "Extracting..."
        tar -xJf "$archive" -C "$dir" --strip-components=1 || { echo "Extraction failed!"; return 1; }

        # Remove the archive after extraction
        rm -f "$archive"
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





##############
#
#
# cmake build
#
alias m='mkdir build && cd build && cmake .. && make'
alias rmm='cd .. && rm -rf build'
#alias db='rm -rf build'
#alias make_back='make > /dev/null 2>&1 &'


cmake_start() {
    project_name=$(basename "$PWD")
    cpp_files=($(find . -type f \( -name "*.cpp" -o -name "*.c" \)))
    h_dirs=($(find . -type f -name "*.h" -exec dirname {} \; | sort -u))

    {
        echo "# Auto-generated CMakeLists.txt"
        echo "cmake_minimum_required(VERSION 3.10)"
        echo "project(${project_name} VERSION 1.0)"
        echo ""
        echo "set(CMAKE_CXX_STANDARD 17)"
        echo "set(CMAKE_CXX_STANDARD_REQUIRED True)"
        echo ""
        echo "# === Source Files ==="
        echo "set(SRC_FILES"
        for file in "${cpp_files[@]}"; do
            echo "    ${file#./}"
        done
        echo ")"
        echo ""
        echo "# === Executable Target ==="
        echo "add_executable(${project_name}_exec \${SRC_FILES})"
        echo ""
        echo "# === Include Directories ==="
        echo "target_include_directories(${project_name}_exec PRIVATE"
        echo "    \${CMAKE_CURRENT_SOURCE_DIR}"
        for dir in "${h_dirs[@]}"; do
            echo "    \${CMAKE_CURRENT_SOURCE_DIR}/${dir#./}"
        done
        echo ")"
        echo ""
        echo "# === Optional: Compiler Warnings ==="
        echo "# Enable common compiler warnings (useful for development)"
        echo "# target_compile_options(main_exec PRIVATE -Wall -Wextra -pedantic)"
        echo ""
        echo "# === Link Libraries ==="
        echo "# - To add more libraries, use additional \`target_link_libraries()\` calls."
        echo "# - To make this reusable: copy this as a template and change project name, source files, and paths."
        echo "# - For better structure, keep external paths in variables or use Find modules."
        echo "# target_link_libraries(${project_name}_exec PRIVATE /home/cnc/Desktop/BUILD_2/raylib/build/raylib/libraylib.a)"
        echo ""
                echo "# Include directories for header files"
        echo "# We are adding two directories here, one from the source folder and one from a third-party library"
        echo "# target_include_directories(my_tetris_game PRIVATE ${CMAKE_SOURCE_DIR}/include)"
        echo "# target_include_directories(my_tetris_game PRIVATE ${CMAKE_SOURCE_DIR}/thirdparty/some_library/include)"
        echo ""
        echo "# Link libraries to the executable"
        echo "# Here, we're linking a static library (raylib) to the project"
        echo "# target_link_libraries(my_tetris_game PRIVATE ${CMAKE_SOURCE_DIR}/libs/raylib.a)"
        echo ""
        echo "# Custom command to copy a file after the build process"
        echo "# add_custom_command("
        echo "#     TARGET my_tetris_game POST_BUILD"
        echo "#     COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/Sounds/music.mp3 ${CMAKE_BINARY_DIR}/build/Sounds/music.mp3"
        echo "# )"
        echo ""
        echo "# Create a custom target that will copy files automatically during the build"
        echo "# add_custom_target(copy_files ALL"
        echo "#     COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/Sounds/music.mp3 ${CMAKE_BINARY_DIR}/build/Sounds/music.mp3"
        echo "# )"
        echo ""
        echo "# Add other build configurations or post-build actions as needed"
        echo "# add_custom_command("
        echo "#     TARGET my_tetris_game POST_BUILD"
        echo "#     COMMAND ${CMAKE_COMMAND} -E echo \"Build completed successfully!\""
        echo "# )"
        echo ""
        echo "# Set the installation directory for the project"
        echo "# The default install directory is /usr/local, but you can change it"
        echo "# set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)"
        echo ""
        echo "# Optionally, you can install the executable and/or libraries"
        echo "# install(TARGETS my_tetris_game DESTINATION ${CMAKE_BINARY_DIR}/install/bin)"
        echo ""
        echo "# Optionally, install headers"
        echo "# install(DIRECTORY ${CMAKE_SOURCE_DIR}/include/ DESTINATION ${CMAKE_BINARY_DIR}/install/include)"
        echo ""
        echo "# Check and print the compiler being used (useful for debugging)"
        echo "# if(MSVC)"
        echo "#     message(\"Using Visual Studio Compiler\")"
        echo "# elseif(CMAKE_COMPILER_IS_GNUCXX)"
        echo "#     message(\"Using GCC Compiler\")"
        echo "# endif()"
        echo ""
        echo "# Find packages for external dependencies"
        echo "# This looks for OpenGL, for example"
        echo "# find_package(OpenGL REQUIRED)"
        echo ""
        echo "# Link the found OpenGL package to the target"
        echo "# target_link_libraries(my_tetris_game PRIVATE OpenGL::GL)"
        echo ""
        echo "# Check for other dependencies or external libraries"
        echo "# find_library(RAYLIB_LIBRARY raylib PATHS /path/to/raylib)"
        echo "# target_link_libraries(my_tetris_game PRIVATE ${RAYLIB_LIBRARY})"
        echo ""
        echo "# If you want to enable tests, you can use this:"
        echo "# enable_testing()"
        echo ""
        echo "# Create a simple test (example: test linking)"
        echo "# add_test(NAME TestHello COMMAND my_tetris_game)"
        echo ""
        echo "# Handle versioning"
        echo "# Automatically makes the version accessible through the ${PROJECT_VERSION} variable"
        echo "# project(MyTetrisGame VERSION 1.0 LANGUAGES CXX)"
        echo ""
        echo "# Show some project info at configuration time"
        echo "# message(\"Project Name: ${PROJECT_NAME}\")"
        echo "# message(\"Project Version: ${PROJECT_VERSION}\")"
        echo "# message(\"C++ Standard: ${CMAKE_CXX_STANDARD}\")"
        echo "# message(\"Build type: ${CMAKE_BUILD_TYPE}\")"
        echo ""
    } > CMakeLists.txt

    echo "CMakeLists.txt generated successfully."
}





#############
#
# Trickster Arts Hackers
# FIX bug alias into function
# git clone https://github.com/Tpj-root/3.0.git
#alias game='cd $HOME/Desktop/MY_GIT/3.0 && ruby sandbox.rb -c stone'

function game(){
    cd $HOME/Desktop/MY_GIT/3.0 && ruby sandbox.rb -c stone
}

#alias test='cd $HOME/Desktop/MY_GIT/3.0 && ruby sandbox.rb -c test_windows'

function test_windows(){
    cd $HOME/Desktop/MY_GIT/3.0 && ruby sandbox.rb -c test_windows
}




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
function raybuild() {
    rm -f *.out  # Remove all .out files in the directory
    g++ "$1"* -o "$1.out" -I/usr/local/include -L/usr/local/lib -lraylib -lm -lpthread -ldl -lX11
    
    if [ -f "$1.out" ]; then
        ./"$1.out"  # Run the program
        rm -f "$1.out"  # Remove the executable after it exits
    fi
}



#############
#   File Encrypt
#   openssl
#
#
# If the key is not found in the specified location, run the function.  
# Alias: needkey -> Adds the SSH key using ssh-add.  
# alias needkey='ssh-add $HOME/Desktop/IM_FILES/id_rsa'  
# Prompt: "Do you need to paste the private key? (yes/no)"  
# If "no", the key will not be copied.  
# The prompt appears only once, the first time.  
# Fix all bugs.  


function create_file() {
    echo "helloword" > id_rsa_2
}


### **Comparison:**
#| **Method**                      | **Security** | **Speed** | **Blocking?** | **Use Case** |
#|---------------------------------|-------------|-----------|--------------|-------------|
#| `/dev/random`                   | ✅✅ High   | 🐢 Slow  | Yes (blocks)  | Ultra-secure keys (PGP, RSA, etc.) |
#| `/dev/urandom`                  | ✅ Secure  | 🚀 Fast  | No (does not block) | Most cryptographic keys |
#| `openssl rand -base64 64`       | ✅ Secure  | 🚀 Fast  | No | General security, encryption |

# 
# Perfect way to make bin
# 1 -> openssl rand -base64 32 >key.bin
# 2 -> 
#
function create_key_bin_file() {
    cat <<EOF | base64 --decode > key.bin2
V053VUhNaHlpOVp2OTJZVTQrT3lmOEhBVnZjVW5SbUpVVWYvaVdhY3Bodz0K
EOF
}


# help Binary File as Text
#  echo "helloworld" | base64 | base64 --decode

# filename : id_rsa
# openssl enc -aes-256-cbc -salt -in id_rsa -out id_rsa.enc -pass pass:MySecretPassword
# openssl enc -aes-256-cbc -d -in id_rsa.enc -out id_rsa3 -pass file:mykey.bin
# openssl enc -aes-256-cbc -d -in id_rsa.enc -out id_rsa3



# converts any binary file to Base64 
# save_bin_to_function <input_filename> <func_name>
#
function save_bin_to_function() {
    local file="$1"
    local func_name="$2"

    if [[ ! -f "$file" ]]; then
        echo "Error: File '$file' not found!"
        return 1
    fi

    echo "$func_name() {"
    echo "    cat <<EOF | base64 --decode > $file"
    base64 "$file"
    echo "EOF"
    echo "}"
}

function my_git_key() {
    cat <<EOF | base64 --decode > id_rsa.enc2
U2FsdGVkX1+5IJK9m6K5fScuVlxVxl+I0bZBjVStmQ4X9UKctb1Y0lSz0BTbYzJ/Hr70oZ7h0tRG
MbDai5JceAqva4kTTVXplRqSJwN2rylnGNX4gLFGOv1NdDlFLxfjpOwTC7bsc9Fq6UVsEqo38rhE
pf+0LU281ypdVUN8cq9USEnLNcwbIB1YP6Qmdae8XB4OcbMjKR2/LDP6zMtftdboM9YiWA==
EOF
}

#############
# 
#   dpkg -l
#
function check_new_packages() {
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
# https://wiki.debian.org/SourcesList
# https://backports.debian.org/Instructions/

alias edit_sources.list='sudo subl /etc/apt/sources.list'
# after run
# sudo apt update

# If there are errors, fix them, then proceed with:
# sudo apt upgrade

# For a full system upgrade:
# sudo apt full-upgrade

# To clean up:
# Unused dependencies – Packages installed automatically but no longer needed.
# Old kernels – If not in use, to free up space.
# sudo apt autoremove

# test list
# apt list --upgradable
#



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

#############
index_array[21]="apt-file" # apt-file command searches available packages for a specific file or files. 
                           # The packages do not need to be installed to perform the search.


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
function check_and_install() {
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
function check_the_condition_SoftWare() {
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
function open_terminals_left_2() {
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
function restartall() {
    sudo systemctl restart renderd apache2
    #sudo systemctl status renderd
    #sudo systemctl status apache2
    clear
}


function stopall() {
    sudo systemctl stop renderd
    sudo systemctl stop apache2
    clear
}
function startall() {
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
alias openxml='cd /usr/share/renderd/example-map/ && echo $((password_set)) | sudo -S xdg-open .'
alias opentiles='cd /var/cache/renderd/tiles/ && echo $((password_set)) | sudo -S xdg-open .'




function map_test() {
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


# Script 1st time run
# 2 time diffrent script
# Needs testing
#
#
#
#
function myhead_connect() {
    BT_MAC="36:48:13:76:54:0B"

    bluetoothctl power on
    sleep 1
    bluetoothctl agent on
    sleep 1
    bluetoothctl scan on
    sleep 3
    bluetoothctl pair $BT_MAC
    sleep 2
    bluetoothctl connect $BT_MAC
    sleep 2
    bluetoothctl trust $BT_MAC
    sleep 1
    bluetoothctl scan off

    echo "Bluetooth headphones connected!"
}

function myhead_disconnect() {
    BT_MAC="36:48:13:76:54:0B"

    bluetoothctl disconnect $BT_MAC
    sleep 1
    echo "Bluetooth headphones disconnected!"
}


# Call the function as needed
# myhead_connect   # To connect
# myhead_disconnect  # To disconnect


find_duplicates() {
    declare -A file_hashes
    while IFS= read -r -d '' file; do
        md5=$(md5sum "$file" | awk '{print $1}')
        file_hashes["$md5"]+="$file"$'\n'
    done < <(find . -type f -print0)

    for hash in "${!file_hashes[@]}"; do
        files=(${file_hashes["$hash"]})
        if [[ ${#files[@]} -gt 1 ]]; then
            echo "Duplicate files found for MD5: $hash"
            printf '%s\n' "${file_hashes["$hash"]}"
            echo "--------------------------------"
        fi
    done
}

#find_duplicates


# This function is dangerous as it changes all file locations to modified, so a flag is needed to ask for two-step verification.
# Function to find and move duplicate files based on their MD5 checksum
# Add the following features:
# - Count duplicates
# - Generate a status report
# - Implement an undo option

find_and_move_duplicates() {

    twoStepVerification || return  # If aborted, exit the function

    declare -A file_hashes  # Declare an associative array to store file paths by hash

    # Step 1: Scan all files recursively and compute their MD5 hash
    while IFS= read -r -d '' file; do
        md5=$(md5sum "$file" | awk '{print $1}')  # Compute MD5 hash of the file
        file_hashes["$md5"]+="$file"$'\n'  # Append file path to the hash key
    done < <(find . -type f -print0)  # Use find with -print0 to handle spaces in filenames

    # Step 2: Process each unique hash and identify duplicate files
    for hash in "${!file_hashes[@]}"; do
        files=()
        
        # Read file list safely into an array
        while IFS= read -r line; do
            [[ -n "$line" ]] && files+=("$line")  # Ensure the line is not empty
        done <<< "${file_hashes["$hash"]}"

        # Step 3: If duplicates exist, move them to a dedicated folder
        if [[ ${#files[@]} -gt 1 ]]; then
            folder="./$hash"  # Folder name is the hash value
            mkdir -p "$folder"  # Create the folder if it doesn't exist
            echo "Moving duplicates to: $folder"

            for file in "${files[@]}"; do
                if [[ -f "$file" ]]; then
                    mv "$file" "$folder/"  # Move the file into the hash-named folder
                else
                    echo "Skipping missing file: $file"
                fi
            done
        fi
    done
}

# Call the function to execute
#find_and_move_duplicates





find_duplicates_dir() {
  main_dir="$1"
  check_dir="$2"

  echo "Scanning for duplicates between:"
  echo "  Main:  $main_dir"
  echo "  Check: $check_dir"
  echo

  find "$main_dir" -type f -exec md5sum {} + | sort > /tmp/main_hashes.txt
  find "$check_dir" -type f -exec md5sum {} + | sort > /tmp/check_hashes.txt

  echo "Duplicate files in $check_dir:"
  join -j1 /tmp/main_hashes.txt /tmp/check_hashes.txt | awk '{for(i=NF;i>1;i--) if($i ~ /^\//) {print $i; break}}'
}



#  
#  Output:
#  
#  It will print only the file paths from the second directory (check_dir) that are duplicates. Example:
#  
#  /home/cnc/Downloads/PCI-SIG/file1.pdf
#  /home/cnc/Downloads/PCI-SIG/specs/old/file2.txt
#  
#  Optional: Delete duplicates (after reviewing)
#  
#  find_duplicates_dir /main/path /check/path > dupes.txt
#  cat dupes.txt | xargs -d '\n' rm -i






# hex help
# view 16*16 = 256 byts
# hexdump -v -e '16/1 "%02X " "\n"' 1.bin

#    hexdump -v -e '16/1 "%02X " "\n"' ATMEL_AT93C56.bin

# OUT
#    7F D0 00 00 00 00 00 00 6E CD 00 00 10 10 00 00
#    7F D0 00 00 85 21 00 00 00 00 00 00 00 00 00 00
#    7F D0 00 00 85 21 00 00 6E CD 00 00 00 FF 00 00
#    6E CD 00 00 85 21 00 00 00 00 DF FB 00 00 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 FF 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
#    07 00 00 00 00 00 00 00 06 FC 00 00 FC 10 00 00
#    07 00 00 00 07 01 00 00 00 00 00 00 00 00 00 00
#    07 00 00 00 07 01 00 00 06 FC 00 00 00 FF 00 00
#    06 FC 00 00 07 01 00 00 00 00 69 5A 00 00 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 FF 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 FF 00 00
#    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


# Gray code ensures that only one bit changes at a time between consecutive values — 
# this reduces errors in hardware like rotary encoders.
# 
# 
#  
#  https://academo.org/demos/logic-gate-simulator/
binary2gray() {
  # binary2gray: Convert binary numbers to Gray code.
  # Usage: binary2gray <bits>
  # Example: binary2gray 3
  # This will generate all binary numbers of 3 bits and their corresponding Gray codes.

  if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
    echo "Usage: binary2gray <bits>"
    echo "Shortcut : Example"
    echo "b2g1: binary2gray 3"
    # use escaped quotes:
    echo "b2g2: binary2gray 3 | awk -F \"->\" '{print \$2}' | tr -d \" \""
    #echo "Description: Generates all binary numbers of <bits> length and converts them to Gray code."
    return
  fi

  bits=$1
  max=$((2**bits))

  for ((i=0; i<max; i++)); do
    # Convert decimal to zero-padded binary
    bin=$(printf "%0${bits}d" "$(echo "obase=2; $i" | bc)")
    # Calculate Gray code: binary XOR (binary shifted right by 1)
    gray_val=$((i ^ (i >> 1)))
    # Convert decimal Gray to zero-padded binary
    gray=$(printf "%0${bits}d" "$(echo "obase=2; $gray_val" | bc)")
    echo "$bin -> $gray"
  done
}

function b2g1() {
    binary2gray 3
}

function b2g2() {
    binary2gray 3 | awk -F "->" '{print $2}' | tr -d " "
}


# more command
# binary2gray 3 | awk -F "->" '{printf "%s\n", $2}'
# binary2gray 3 | awk -F "->" '{print $2}' | tr -d " "
#



# FIXME
kicad_online_view() {
  if pgrep -x "firefox" > /dev/null; then
    # Firefox is already running, open a new tab
    xdotool search --onlyvisible --class "Firefox" windowactivate --sync key ctrl+t
    xdotool type "https://kicanvas.org/"
    xdotool key Return
  else
    # Firefox is not running, open a new window with the URL
    firefox https://kicanvas.org/
  fi
}




# railway_to_normal "18:45"  # Outputs: 06:45 PM
railway_to_normal() {
    date -d "$1" +"%I:%M %p"
}


# search_words function
#
# This function searches recursively through the current directory and its subdirectories 
# for a given search string (word or phrase). It uses `grep` to perform the search.
# 
# Usage:
#   search_words "your_search_string"
#
# Arguments:
#   $1 - The search string to find. You must enclose the string in quotes if it contains spaces.
#
# Example:
#   search_words "Added drilling 13/5/2010"
#
# Output:
#   This function will print all lines containing the search string along with the filenames.
#   Any errors related to unreadable files will be suppressed.
#
# Notes:
#   - This function uses `grep -r` to perform a recursive search.
#   - `2>/dev/null` is used to suppress error messages, such as those for unreadable files.
#
# Author: [Tpj-root]
# Date: [12-04-2025]

search_words() {
  # Recursively search for the string provided as the first argument in the current directory
  # and all its subdirectories. Suppresses error messages.
  grep -r "$1" ./* 2>/dev/null
}




# --------------------------------------------
# Function: qr_Decoder
# Description:
#   Decodes a QR code from an image file using `zbarimg`.
#   Automatically installs `zbar-tools` if it's missing.
#
# Usage:
#   qr_Decoder <image_file>
#
# Parameters:
#   <image_file> - Path to the image containing the QR code.
#
# Returns:
#   Prints the decoded QR code content.
#
# Notes:
#   - Requires sudo permission to install packages if missing.
#   - Accepts only local file paths.
#   - zbar-tools is for scanning/reading QR codes, not generating
#
# Example:
#   qr_Decoder my_qr.png
# --------------------------------------------

function qr_Decoder() {
    # Check if zbarimg is installed
    if ! command -v zbarimg &> /dev/null; then
        echo "zbar-tools is not installed. Installing zbar-tools..."
        sudo apt install -y zbar-tools
        # Recheck after installation
        if ! command -v zbarimg &> /dev/null; then
            echo "Failed to install zbar-tools. Please install it manually and try again."
            echo "Manual command: sudo apt-get install zbar-tools"
            return 1
        fi
    fi

    # Check if an image file is provided
    if [ -z "$1" ]; then
        echo "Usage: qr_Decoder <image_file>"
        return 1
    fi

    # Check if the image file exists
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' not found."
        return 1
    fi

    # Decode and print the QR code content
    zbarimg --raw -q "$1"
}



# Decode QR Code from Webcam
# zbarcam
# https://manpages.debian.org/unstable/zbar-tools/zbarimg.1.en.html


# Function: gen_hex_filename
# Purpose : Generate a random 6-digit hexadecimal string
# Returns : A string like "3FA2B7" (uppercase), suitable for use as a filename
# Usage   : filename=$(gen_hex_filename)

function gen_hex_filename() {
    # Generate a random number using $RANDOM * $RANDOM
    # Then take modulo 0xFFFFFF (16777215) to ensure it fits in 6 hex digits
    local rand_value=$((RANDOM * RANDOM % 0xFFFFFF))

    # Print the number in 6-digit uppercase hexadecimal format with leading zeros
    printf "%06X" "$rand_value"
}




function qr_Encoder() {
    # Check if qrencode is installed
    if ! command -v qrencode &> /dev/null; then
        echo "qrencode is not installed. Installing..."
        sudo apt install -y qrencode
        if ! command -v qrencode &> /dev/null; then
            echo "Failed to install qrencode. Please install it manually."
            return 1
        fi
    fi

    # Check if input is provided
    if [ -z "$1" ]; then
        echo "Usage: qr_Encoder <input_url_or_text>"
        return 1
    fi


    local filename="$(gen_hex_filename).png"
    # Generate QR in terminal and save as image
    qrencode -t ANSIUTF8 "$1"

    # qrencode -o tiny.png -s 1 "your text"
    # Use -s 1 for the smallest size (each QR module = 1 pixel).
    # qrencode -o huge.png -s 10 "your text"
    # This will create a larger and higher resolution QR code. 
    #qrencode -o "$filename" -s 10 "$1"
    qrencode -o "$filename" "$1"
    echo "QR code saved as $filename"
}

# alias
# 

#alias qr_D='qr_Decoder'
#alias qr_E='qr_Encoder'


# My Own alias start from my keywords
alias sab_qr_D='qr_Decoder'
alias sab_qr_E='qr_Encoder'

#alias sab_='echo "Hello_iam_sab"'





# How to store the diffrent file_( channel)
# Record the audio
# ffmpeg -f pulse -i alsa_input.usb-USB_2.0_USB_Audio_Device_08613544166500-00.mono-fallback        -f pulse -i alsa_output.usb-USB_2.0_USB_Audio_Device_08613544166500-00.analog-stereo.monitor        -filter_complex amix=inputs=2:duration=longest output_2.mp3

# MY audio
# ffmpeg -f pulse -i default -f pulse -i alsa_output.pci-0000_00_1b.0.analog-stereo.monitor -filter_complex amix=inputs=2:duration=longest output.mp3

# Tele Audio only
# ffmpeg -f pulse -i alsa_output.usb-USB_2.0_USB_Audio_Device_08613544166500-00.analog-stereo.monitor output_telegram_only.mp3








# git_tag_help

function git_help() {

    echo "git tag -a v0.1 -m \"Release version 0.1\""
    echo "git push origin v0.1"
    echo "all in one push"
    echo "git push --tags"
    echo ""


}



download_flickr_image() {
  local url="$1"
  local html image_url
  html=$(curl -s "$url")
  image_url=$(echo "$html" | grep -oP 'https://live\.staticflickr\.com/[0-9]+/[0-9]+_[a-z0-9]+_b\.jpg' | head -n1)
  if [[ -n "$image_url" ]]; then
    echo "Downloading: $image_url"
    curl -O "$image_url"
  else
    echo "Image URL not found."
  fi
}

# https://www.flickr.com/photos/osr/albums/72157663504344334/with/25838333416
# https://www.flickr.com/photos/osr/46222592501
#   <meta property="og:image" content="https://live.staticflickr.com/8571/15401767363_83ff1c34d2_z.jpg"  data-dynamic="true">
download_flickr_image1() {
    local flickr_url="$1"
    local page_html
    page_html=$(curl -sL "$flickr_url")
    
    local image_url
    image_url=$(echo "$page_html" | grep -oP 'https://live\.staticflickr\.com/[^"]+\.jpg' | head -n1)
    
    if [[ -n "$image_url" ]]; then
        echo "Downloading: $image_url"
        wget "$image_url"
    else
        echo "Image URL not found."
    fi
}





## # 
## ## xxd - make a hexdump or do the reverse.
## 
## ## -g
## 
## given pin value : CD E3 8F 62 59 60
## 
## CD --> offset --> 0x110 + 13 = 0x11D (or 285 in decimal)
## E3 --> offset --> 0x170 + 12
## 8F --> offset --> 0x190 + 5
## 62 --> offset --> 0x110 + 10 or 0x0d0 + 0 
## 59 --> offset --> 0x120 + 1
## 60 --> offset --> 0x170 + 13
## 
## 
## TEST_1
## xxd -s 0x11D -l 1 sablogantest.bin --- > 0000011d: cd          
## 
## 
## Math : 
## printf "0x%x\n" $((0x110 + 13))
## 
## # To print decimal instead, use:
## printf "%d\n" $((0x110 + 13))
## 
## 
## 
## 
xxd16() {
  xxd -g 2 -c 16 "$1"
}


startline() {
  for ((i=0; i<30; i++)); do
    echo -n "*"
  done
  echo
}



#
logan_bin_reader() {
  local file=$1
  local offsets=(
    "0x110+13"
    "0x170+12"
    "0x190+5"
    "0x110+10"
    "0x190+2"
    "0x170+13"
  )
  local bytes=()

  for off in "${offsets[@]}"; do
    local base=$(( $(echo $off | cut -d'+' -f1) ))
    local add=$(( $(echo $off | cut -d'+' -f2) ))
    local pos=$(( base + add ))

    local byte=$(xxd -s $pos -l 1 -p "$file" | tr '[:lower:]' '[:upper:]')
    bytes+=("$byte")
  done
  startline
  echo "Renault Logan EEPROM Bin Reader"
  echo "CHIP NO :"
  echo "File size : 512 bytes "
  startline
  echo "${bytes[*]}"
  echo "${bytes[*]}" | tr -d ' '
  startline
}




my_hash_sums() {
  local file="$1"
  local max_size=$((10 * 1024 * 1024)) # 10MB

  if [ ! -f "$file" ]; then
    echo "File not found: $file"
    return 1
  fi

  local size
  size=$(stat -c%s "$file")

  if [ "$size" -gt "$max_size" ]; then
    echo "File size is too large (>10MB): $file"
    return 1
  fi

  echo "File: $file"
  echo "Size: $size bytes"
  echo "MD5:       $(md5sum "$file" | awk '{print $1}')"
  echo "SHA1:      $(sha1sum "$file" | awk '{print $1}')"
  echo "SHA224:    $(sha224sum "$file" | awk '{print $1}')"
  echo "SHA256:    $(sha256sum "$file" | awk '{print $1}')"
  echo "SHA384:    $(sha384sum "$file" | awk '{print $1}')"
  echo "SHA512:    $(sha512sum "$file" | awk '{print $1}')"
}




# ┌───────────────────────────────────────────────────┐
# │ Function: boxfunction                             │
# │ Description: Draws a box around input text        │
# │ Usage: boxfunction "your message here"            │
# │ Output:                                           │
# │ ┌───────────────┐                                 │
# │ │ Hello World   │                                 │
# │ └───────────────┘                                 │
# └───────────────────────────────────────────────────┘

boxfunction() {
  local text="$*"                     # Join all arguments as a single string
  local len=${#text}                 # Get string length
  local border                       # Horizontal line based on length

  border=$(printf '─%.0s' $(seq 1 $len))  # Repeat '─' to match text width

  echo "┌─${border}─┐"              # Top border
  echo "│ ${text} │"               # Text line
  echo "└─${border}─┘"              # Bottom border
}


color_boxfunction() {
  local text="$*"
  local len=${#text}
  local border=$(printf '─%.0s' $(seq 1 $len))

  # Default color: Yellow (33). You can override it.
  local color_code="${COLOR:-33}"

  # ANSI color start and reset
  local start="\e[1;${color_code}m"
  local reset="\e[0m"


  echo -e "${start}┌─${border}─┐${reset}"
  echo -e "${start}│ ${text} │${reset}"
  echo -e "${start}└─${border}─┘${reset}"

}

## 
## ### ✅ **Conventional Commit Types**
## 
## | Type       | Purpose                                     | Example Commit Message                      |
## | ---------- | ------------------------------------------- | ------------------------------------------- |
## | `feat`     | New feature                                 | `feat: add user login functionality`        |
## | `fix`      | Bug fix                                     | `fix: resolve crash on null user input`     |
## | `chore`    | Maintenance tasks (no production change)    | `chore: update dependencies`                |
## | `docs`     | Documentation only                          | `docs: add API usage examples`              |
## | `style`    | Code formatting (no logic change)           | `style: fix indentation in main.py`         |
## | `refactor` | Code change without changing behavior       | `refactor: optimize loop performance`       |
## | `test`     | Adding or fixing tests                      | `test: add unit tests for auth module`      |
## | `perf`     | Performance improvement                     | `perf: improve response time for dashboard` |
## | `build`    | Build system or external dependency changes | `build: update Dockerfile to use alpine`    |
## | `ci`       | Continuous integration config changes       | `ci: update GitHub Actions node version`    |
## | `revert`   | Reverts a previous commit                   | `revert: revert login page redesign`        |
## 
## ---
## 
## Use this format:
## 
## ```
## <type>: <short summary>
## ```
## 
## Optionally:
## 
## ```
## <type>(scope): <summary>
## ```
## 
## Example:
## 
## ```bash
## git commit -m "feat(cli): add support for config file"
## ```
## 



# tamil fm
alias tamil_fm='vlc https://tamilkaterumbufm-prabak78.radioca.st/stream'






### CPP _HELP
###
###

list_sorted_headers() {
  grep -rohE '#include\s+[<"].+[>"]' . --include=\*.{cpp,hpp} | sort -u | \
  awk '/<.*>/{print > "/tmp/angle_headers"} /".*"/{print > "/tmp/quote_headers"}'
  sort /tmp/angle_headers
  sort /tmp/quote_headers
  rm /tmp/angle_headers /tmp/quote_headers
}





extract_commits() {
  git_repo="https://github.com/iforce2d/scv"
  working_dir="scv_temp"
  mkdir -p "$working_dir"
  cd "$working_dir" || exit

  git clone "$git_repo" repo
  cd repo || exit

  commits=(
    8ab5f5ae542f608ef90c86eb62729cb67dbc20b2
    76d102cc324da814c9a75bec81a6baf9ce3d1996
    0cdd5ecd63235d16a6081cff9d7a7441a3aa66b2
    00c356c92d5ada41b9eb37a7445652994525d226
    83a891fc6c1f1826ebfef88d3046461e7c32f934
    8a1375b00a415228832dfb0e6e0b9dd3ba74b547
    28886926beb15b9a6b7637214b1cc07305c4cdb7
    97e64143fef8be499307fbbb55b899118a94a824
    d71169d964f2aeff3cc8f6a7414a4c2c6106e4b4
    827c1ebdd1f078cc960f928f391afa39bdd35450
    d30bbfd261b5535483407f327caad12348157ff2
    478314d16d6dcfac621e8f508a2b3852248e75af
    ae2e8343e6dcbb1dcbd255695120c82b657f3111
    04a6a602d8219e552a4bac73bea0976e19921cfd
    1adba70607026b90fd1e3f0db9634c8c23d10730
    2aa39f4993aef1858347e393cd56c788aec45770
    c52bb1cb1889c415465d93f0f77a52135487c3d5
    0ab205c6fe888a9e7000ae98017c750ecd8c8420
    8e56c93a180588d54b6403bb570316d39b52e8a0
  )

  for hash in "${commits[@]}"; do
    echo "Checking out $hash..."
    git checkout "$hash" --quiet
    dest_dir="../commit_$hash"
    mkdir -p "$dest_dir"
    git ls-files | xargs -I{} cp --parents {} "$dest_dir"
  done

  echo "Done. All commits copied."
}





# simple bash function that takes your three inputs—URL pattern, start, end
# and downloads each .jpg in that range using wget

# download_range: Download .jpg files from URL pattern replacing '*' with numbers in a range
download_range() {
  local url_pattern="$1"   # e.g. https://slifty.com/.../*.jpg
  local start="$2"         # starting number, e.g. 1
  local end="$3"           # ending number, e.g. 16
  local i

  # Check inputs
  if [[ -z "$url_pattern" || -z "$start" || -z "$end" ]]; then
    echo "Usage: download_range <url_pattern> <start> <end>"
    echo "e.g. download_range \"https://slifty.com/.../*.jpg\" 1 16"
    return 1
  fi

  echo "Downloading files from ${url_pattern/\*/$start}.jpg to /*/$end.jpg …"

  # Loop with seq, zero-padded if needed
  for i in $(seq "$start" "$end"); do
    url="${url_pattern/\*/$i}.jpg"
    echo "→ Fetching $url"
    wget -c -q "$url" -O "$(basename "$url")" && \
      echo "   ✔ saved as $(basename "$url")" || \
      echo "   ⚠ failed: $url"
  done

  echo "All done!"
}


#### 🛠️ Breakdown of Commands
#
#* `local url_pattern="$1"`: captures the URL pattern with `*`.
#* `seq "$start" "$end"`: generates numbers from start to end. ([phoenixnap.com][1], [superuser.com][2], [reddit.com][3])
#* `"${url_pattern/\*/$i}.jpg"`: replaces `*` with the iteration number.
#* `wget -c -q "$url"`: continues partially downloaded files and runs quietly (only errors).
#* `-O "$(basename "$url")"`: saves the file with just its base name.
#* `&& … || …`: prints success (✔) or failure (⚠).
#
#
#
#**What it does:**
#
#* Downloads files numbered 1.jpg, 2.jpg, … up to 16.jpg.
#* Continues interrupted downloads (`-c`), suppresses extra output (`-q`).
#* Displays a success or failure message per file.
#---
#
#
#
#### ✅ Optional Enhancements
#
#* **Zero-padded numbers**: If your files are named `01.jpg`–`16.jpg`, update the loop:
#
#  ```bash
#  for i in $(seq -w "$start" "$end"); do
#  ```
#* **Parallel downloads**:
#
#  ```bash
#  seq "$start" "$end" | xargs -n1 -P4 -I{} wget -c -q "${url_pattern/\*/{}}.jpg"
#  ```
#
#  *(Downloads 4 files at once)* ([w3schools.com][4])



# join_range: horizontally concatenates numbered .jpg files in a range into one output image
join_range() {
  local start="$1"
  local end="$2"
  local output="${3:-joined.jpg}"
  local files=()

  # Input validation
  if [[ -z "$start" || -z "$end" ]]; then
    echo "Usage: join_range <start> <end> [output_filename]"
    echo "Example: join_range 1 16 combined.jpg"
    return 1
  fi

  # Build list of files
  for i in $(seq "$start" "$end"); do
    files+=("${i}.jpg")
  done

  # Check files exist
  missing=()
  for f in "${files[@]}"; do
    [[ -f "$f" ]] || missing+=("$f")
  done
  if (( ${#missing[@]} )); then
    echo "Error: Missing files: ${missing[*]}"
    return 1
  fi

  # Concatenate horizontally
  echo "Joining ${#files[@]} files from ${start}.jpg to ${end}.jpg into '$output'..."
  convert "${files[@]}" +append "$output"

  if (( $? == 0 )); then
    echo "✅ Created: $output"
  else
    echo "❌ Failed to create: $output"
    return 1
  fi
}



# join_images: join numbered images with prefix, optionally resized, either horizontally or vertically
# Usage: join_images <prefix> <start> <end> <orientation[h|v]> [output_filename]
join_images() {
  local prefix="$1"
  local start="$2"
  local end="$3"
  local orient="$4"
  local output="${5:-${prefix}_joined.jpg}"
  local tmpdir=$(mktemp -d)
  local files=()

  if [[ -z "$prefix" || -z "$start" || -z "$end" || ! "$orient" =~ ^[hv]$ ]]; then
    echo "Usage: join_images <prefix> <start> <end> <h|v> [output_filename]"
    echo " e.g. join_images A 0 5 h combinedA.jpg"
    echo "     joins A_0.jpg … A_5.jpg side‑by‑side"
    return 1
  fi

  # Resize each image (max 2000px) and collect in temp dir
  for i in $(seq "$start" "$end"); do
    local f="${prefix}_${i}.jpg"
    if [[ ! -f "$f" ]]; then
      echo "❌ Missing file: $f"; rm -rf "$tmpdir"; return 1
    fi
    local tf="${tmpdir}/${prefix}_${i}.jpg"
    convert "$f" -resize 2000x2000\> "$tf"
    files+=("$tf")
  done

  # Choose append direction
  local mode="h"
  [[ "$orient" == "h" ]] && mode="+append" || mode="-append"
  
  echo "🔗 Joining ${#files[@]} files in ${orient^^} mode into '$output' ..."
  convert "${files[@]}" $mode "$output" \
    && echo "✅ Created '$output'" \
    || { echo "❌ Failed to create '$output'"; rm -rf "$tmpdir"; return 1; }

  rm -rf "$tmpdir"
}


# stack_vertical_many: stacks multiple images vertically into one output file
# Usage: stack_vertical_many <output.jpg> <input1.jpg> <input2.jpg> [<input3.jpg> ...]
stack_vertical_many() {
  local output="$1"
  shift
  local inputs=("$@")

  # Validate inputs
  if [[ -z "$output" || ${#inputs[@]} -lt 2 ]]; then
    echo "Usage: stack_vertical_many <output> <input1> <input2> [<input3> ...]"
    echo "Example: stack_vertical_many final.jpg A_joined.jpg B_joined.jpg"
    return 1
  fi

  # Ensure all input files exist
  for img in "${inputs[@]}"; do
    if [[ ! -f "$img" ]]; then
      echo "❌ Missing input file: $img"
      return 1
    fi
  done

  # Perform vertical stacking
  echo "🔽 Stacking ${#inputs[@]} images vertically into '$output'..."
  convert "${inputs[@]}" -append "$output" \
    && echo "✅ Created '$output'" \
    || { echo "❌ Failed to create '$output'"; return 1; }
}


# To scan only the current directory (not subfolders), change find . to find . -maxdepth 1:
convert_all_images() {
  # Find all image files in current directory (no subdirs), matching jpg, jpeg, png, or webp
  find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
  while read -r img; do
    # Get output file name by replacing extension with .png
    out="${img%.*}.png"
    
    # Use ImageMagick's 'convert' to convert the image to PNG
    convert "$img" "$out"
    
    # Print conversion status
    echo "✅ Converted: $img -> $out"
  done
}



######################
#
#  File Related commands and function
#
######################  
#
#  START_000FILE
#  END_000FILE
# 
######################  


######################
# 
# Count files by extension
#
files_count_extensions() {
  find . -type f | sed -n 's/.*\(\.[^./]*\)$/\1/p' | sort | uniq -c | sort -nr
}
#
######################


######################
# 
#  # This function lists all files with a given extension (case-insensitive),
#
# ####################
list_by_extension() {
 
  # searching recursively from the current directory.
  # 👉 Show help if no argument or '--help' is passed
  if [[ $# -ne 1 || "$1" == "--help" ]]; then
    echo "Usage: list_by_extension <extension>"
    echo
    echo "Recursively list all files with a given file extension."
    echo "Matching is case-insensitive (e.g., .txt, .TXT, .Txt)."
    echo
    echo "Arguments:"
    echo "  <extension>   File extension to search for (with or without leading dot)"
    echo
    echo "Example:"
    echo "  list_by_extension txt"
    echo "  list_by_extension .jpg"
    return
  fi

  # 📂 Remove leading dot if user typed it
  ext="${1#.}"

  # 🔍 Find all files matching *.ext (case-insensitive)
  find . -type f -iname "*.${ext}"
}



# list_files_by_size | grep MB | sort
# list_files_by_size | grep MB | sort | grep -i PDF
# list_files_by_size | grep -i jpg | grep " MB" | awk '$1+0 > 2'


list_files_by_size() {
  # This function lists all files under the current directory (recursively),
  # sorted by size (ascending), grouped by their top-level directory.
  # It displays file sizes in human-readable format (e.g., KB, MB).

  find . -type f -printf "%s %p\n" | sort -n | awk '
  # Function to convert bytes to human-readable size
  function human(x) {
    split("B KB MB GB TB", unit)
    i = 1
    while (x >= 1024 && i < 5) {
      x /= 1024
      i++
    }
    return sprintf("%.1f %s", x, unit[i])
  }

  {
    size = $1        # Get file size in bytes
    $1 = ""          # Remove the size from the line
    sub(/^ /, "", $0)  # Trim leading space
    split($0, path_parts, "/")  # Split the file path by "/"
    dir = (length(path_parts) > 1) ? path_parts[2] : "."  # Get top-level dir
    files[dir] = files[dir] human(size) " " $0 "\n"  # Append file info to group
  }

  END {
    for (d in files) {
      print "Directory: " d
      printf "%s", files[d]
      print ""
    }
  }'
}




# you can **easily add more categories or extensions** in the future using simple Bash array and `case` structure.
#  
#  ---
#  
#  ### 🧠 Bash Tip: Add New Extension Group
#  To add a new group, you need to:
#  
#  ---
#  
#  ### ✅ Step 1: **Define a new array for the group**
#  
#  Each array holds a list of extensions for one category.
#  You can add like this:
#  
#  ```bash
#  # New group: Documents
#  extensions_3=("pdf" "docx" "xls")
#  ```
#  
#  ---
#  
#  ### ✅ Step 2: **Update the `echo` menu and `case` block**
#  
#  Add new choice to prompt:
#  
#  ```bash
#  echo "4. Documents (.pdf, .docx, .xls)"
#  ```
#  
#  And add the case to select the right array:
#  
#  ```bash
#  4) selected_extensions=("${extensions_3[@]}") ;;
#  ```
#  
#  ---
#  
#  ### 💡 Complete Example for Adding New Group:
#  
#  #### 🔧 Modify this part:
#  
#  ```bash
#  # Existing groups
#  extensions_0=("png" "jpg")
#  extensions_1=("comp")
#  extensions_2=("c" "cpp")
#  
#  # 🆕 New group
#  extensions_3=("pdf" "docx" "xls")   # Add your extensions here
#  ```
#  
#  #### 📋 Modify the user prompt:
#  
#  ```bash
#  echo "0. Images (.png, .jpg)"
#  echo "1. LinuxCNC (.comp)"
#  echo "2. Code (.c, .cpp)"
#  echo "3. Documents (.pdf, .docx, .xls)"    # Add new menu line
#  ```
#  
#  #### ⚙️ Add new case in the `case` block:
#  
#  ```bash
#  case $choice in
#      0) selected_extensions=("${extensions_0[@]}") ;;
#      1) selected_extensions=("${extensions_1[@]}") ;;
#      2) selected_extensions=("${extensions_2[@]}") ;;
#      3) selected_extensions=("${extensions_3[@]}") ;;  # Handle new group
#      *) echo "Invalid choice. Exiting."; return 1 ;;
#  esac
#  ```
#  
#  ---
#  
#  ### 🧪 How It Works (Bash Concepts):
#  
#  | Bash Concept                     | Explanation                                        |
#  | -------------------------------- | -------------------------------------------------- |
#  | `arrays`                         | Hold multiple file extensions like `"png" "jpg"`   |
#  | `read -p`                        | Takes user input for choice or directory           |
#  | `case ... esac`                  | Matches user input and selects the correct array   |
#  | `"${array[@]}"`                  | Expands all items in the array                     |
#  | `mkdir -p`                       | Creates folder only if it doesn't exist            |
#  | `find . -type f -iname "*.$ext"` | Finds files recursively by extension               |
#  | `basename "$filepath"`           | Gets filename from full path                       |
#  | `openssl rand -hex 3`            | Generates random 6-char suffix if file name exists |
#  
#  ---
#  
#  ### ✅ Summary:
#  
#  To add more:
#  
#  1. Define a new array: `extensions_4=("new" "types")`
#  2. Add `echo "5. Something (.new .types)"`
#  3. Add `5) selected_extensions=("${extensions_4[@]}") ;;`
#  
#  Let me know if you want auto-detect from folders or JSON/INI config loading.

## 
## 💡 Tip (for many choices):
## 
## Instead of long case, you can use arrays + index:
## 
## extensions_list=(ext0 ext1 ext2 ext3 ext4 ... ext99)
## 
## read -p "Enter choice (0–99): " choice
## 
## # Check if numeric and in range
## if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 0 && choice < ${#extensions_list[@]} )); then
##     selected="${extensions_list[$choice]}"
##     echo "You selected: $selected"
## else
##     echo "Invalid choice"
## fi


# 
#   extensions_3=("pdf" "docx" "xls")
#   echo "4. Documents (.pdf, .docx, .xls)"
#   selected_extensions=("${extensions_3[@]}") ;;


files_organize_and_copy_to_target() {
    # Show usage if --help is passed
    if [[ "$1" == "--help" ]]; then
        echo "Usage: organize_and_copy_files"
        echo
        echo "This function organizes files into folders by extension."
        echo "It supports predefined categories like images, code, documents, etc."
        echo
        echo "You will be prompted to:"
        echo "  - Choose a file category (0–3)"
        echo "  - Enter a destination folder"
        echo
        echo "Example:"
        echo "  organize_and_copy_files"
        return
    fi

    # Category 0: Image files
    extensions_0=("png" "jpg")

    # Category 1: LinuxCNC related files
    extensions_1=("comp")

    # Category 2: Code and source files
    extensions_2=("c" "cpp")

    # Category 3: Document files
    extensions_3=("pdf" "docx" "xls" "txt")

    # Step 1: Ask user to select a category
    echo "Select file category to organize:"
    echo "0. Images (.png, .jpg)"
    echo "1. LinuxCNC (.comp)"
    echo "2. Code (.c, .cpp)"
    echo "3. Documents (.pdf, .docx, .xls, .txt)"
    echo "q. Quit"
    read -p "Enter choice (0/1/2/3/q): " choice
    
    # Step 2: Set the selected extensions array
    case $choice in
        0) selected_extensions=("${extensions_0[@]}") ;;
        1) selected_extensions=("${extensions_1[@]}") ;;
        2) selected_extensions=("${extensions_2[@]}") ;;
        3) selected_extensions=("${extensions_3[@]}") ;;
        q) echo "Quitting..."; return ;;
        *) echo "Invalid choice. Exiting."; return 1 ;;
    esac


    # Step 3: Ask user for the destination directory to copy files
    read -p "Enter target directory to copy files into: " target_base

    # Step 4: Create the base target directory if it doesn't exist
    mkdir -p "$target_base"

    # Step 5: Loop through selected extensions
    for ext in "${selected_extensions[@]}"; do
        # Create subdirectory under target for each extension
        mkdir -p "$target_base/$ext"

        # Step 6: Find all matching files in current and subdirectories
        find . -type f -iname "*.$ext" | while read -r filepath; do
            filename=$(basename "$filepath")
            target_path="$target_base/$ext/$filename"

            # Rename if file already exists
            if [[ -e "$target_path" ]]; then
                suffix=$(openssl rand -hex 3)
                base="${filename%.*}"
                new_filename="${base}_${suffix}.$ext"
                target_path="$target_base/$ext/$new_filename"
            fi

            # Copy file
            cp "$filepath" "$target_path"
        done
    done

    # Final message and open folder
    xdg-open "$target_base" 2>/dev/null
    echo "✅ All matching files copied to: $target_base"
}






# Example
# copy_data .jpg /home/user/pics/
# 
#
copy_data() {
    # Store the first argument as the file pattern (e.g., ".png" or ".txt")
    local pattern="$1"

    # Store the second argument as the target directory to copy files into
    local target_dir="$2"

    # Check if either argument is missing (pattern or destination)
    if [[ -z "$pattern" || -z "$target_dir" ]]; then
        # Print usage message if inputs are missing
        echo "Usage: copy_data <pattern> <destination_dir>"
        return 1  # Exit function with error
    fi

    # Create the destination directory if it doesn't exist
    # -p makes parent directories if needed, and does nothing if already exists
    mkdir -p "$target_dir"

    # Search recursively from current directory (.)
    # -type f       → only regular files (not directories)
    # -iname        → case-insensitive match of filenames (e.g., .PNG, .png)
    # "*$pattern"   → wildcard match; matches any filename ending with pattern
    # -exec cp -v   → copy each found file to target directory
    # {}            → placeholder for each found file
    # \;            → ends the -exec command
    find . -type f -iname "*${pattern}" -exec cp -v {} "$target_dir" \;
}

#
#
# copy_data .mp3 /home/user/music/
copy_data_dup() {
    # Store the first input argument as the pattern (e.g., ".png")
    local pattern="$1"

    # Store the second input argument as the target directory to copy files into
    local target_dir="$2"

    # Check if both pattern and destination path are provided
    if [[ -z "$pattern" || -z "$target_dir" ]]; then
        echo "Usage: copy_data <pattern> <destination_dir>"
        return 1  # Exit function with error code
    fi

    # Create the destination folder if it doesn't exist
    mkdir -p "$target_dir"

    # Find all files (case-insensitive match) in current and subdirectories that match the pattern
    find . -type f -iname "*${pattern}" | while read -r src_file; do

        # Get just the filename from the full path (e.g., "photo.png")
        filename=$(basename "$src_file")

        # Build the full destination file path (e.g., "/target/path/photo.png")
        dest_file="$target_dir/$filename"

        # Check if a file with the same name already exists in the destination
        if [[ -f "$dest_file" ]]; then
            # If it exists, calculate MD5 hash of both source and destination files
            src_md5=$(md5sum "$src_file" | awk '{print $1}')
            dest_md5=$(md5sum "$dest_file" | awk '{print $1}')

            # Compare the checksums
            if [[ "$src_md5" == "$dest_md5" ]]; then
                # If both files are identical, skip copying
                echo "SKIP: $filename (identical file exists)"
                continue
            else
                # If contents are different, generate a new filename with a random 5-digit hex
                rand_hex=$(printf "%05x" $((RANDOM * RANDOM)))

                # Separate the filename and extension and append the hex
                # Example: "photo.png" → "photo_ab123.png"
                new_filename="${filename%.*}_${rand_hex}.${filename##*.}"

                # Copy the file using the new name to avoid overwrite
                cp -v "$src_file" "$target_dir/$new_filename"
            fi
        else
            # If no file exists in destination with that name, copy directly
            cp -v "$src_file" "$dest_file"
        fi

    done
}


###################  
#
#  START_000FILE
#  END_000FILE
# 
###################





######################
#
#  Github Readme edit helps
#
######################  
#
#  START_001GITHUB_README
#  END_001GITHUB_README
# 
######################  

function github_help () {
cat <<EOF

EOF
}


## # Project Name
## 
## Short description of your project.
## 
## ## Features
## - Feature 1
## - Feature 2
## 
## ## Installation
## Run the following in your terminal:
## 
##     git clone https://github.com/your-username/your-repo.git
##     cd your-repo
## 
## ### ✅ 3. Add an image
## 
## Use this syntax:
## 
## ### ```markdown
## ### ![Alt text](image_url)
## 
## ![Logo](https://github.com/your-username/your-repo/raw/main/images/logo.png)
## 
## 
##  Or for a local image in repo:
## ![Screenshot](images/screenshot.png)

## Use HTML inside your Markdown to place images side by side on GitHub:
## <p float="left">
##   <img src="image/group_cb_brackets.jpg" width="200"/>
##   <img src="image/Group_of_Blank.jpg" width="200"/>
##   <img src="image/Group_of_cutouts.jpg" width="200"/>
## </p>
##   



###################  
#
#  START_001GITHUB_README
#  END_001GITHUB_README
# 
###################  




######################
#
#  Basic_tools
#
######################  



### 00001

# https://github.com/pdfcpu/pdfcpu/releases
# `pdfcpu_0.10.1_Linux_x86_64` is the precompiled binary for Linux (64-bit) of **[pdfcpu](https://github.com/pdfcpu/pdfcpu)** — a PDF processing tool written in Go.
# 
# You can use it to:
# 
# * Merge, split, rotate, trim PDFs
# * Add/remove watermarks
# * Encrypt/decrypt PDFs
# * Extract images, fonts, etc.
# 
# ### Example usage:
# 
# ```bash
# ./pdfcpu_0.10.1_Linux_x86_64 merge output.pdf file1.pdf file2.pdf
# ```
# 
# Make sure to give it execute permission:
# 
# ```bash
# chmod +x pdfcpu_0.10.1_Linux_x86_64
# ```



function nice_view_plan_0() {

    seq 1 100 | column | awk '{
      for (i = 1; i <= NF; i++) {
        if (i == 3)
          printf "\033[1;31m%s\033[0m\t", $i;  # red
        else
          printf "%s\t", $i;
      }
      print "";
    }'

}


function nice_view_plan_1() {
    seq 1 20 | paste - - -

}



itype2() {
  echo "$*" | trans -b -s en -t ta --no-auto
}



itype() {
  input="$*"
  while IFS='=' read -r key value; do
    input=$(echo "$input" | sed "s/$key/$value/g")
  done < ~/Desktop/MY_GIT/Decode_MyLife_WhoAmI/tanglish_map.txt
  echo "$input"
}




## rm() {
##   # Check if the user is trying to remove the root directory or using --no-preserve-root
##   if [[ "$*" == *"--no-preserve-root"* || "$*" == *" /"* || "$*" == "/"* ]]; then
##     # Warn the user and block the operation
##     echo "⚠️ Dangerous 'rm' command blocked for safety!"
##     return 1  # Exit the function with an error code
##   else
##     # If the command is safe, run the actual rm command with the given arguments
##     command rm "$@"  # 'command' ensures we call the real /bin/rm, not this function again
##   fi
## }
## 



rename_spaces_to_underscores() {
  #
  # This function renames all files in the current directory
  # by replacing spaces (" ") and hyphens ("-") with underscores ("_").
  #

  for file in *; do
    [ -f "$file" ] || continue

    #
    # Replace all spaces and hyphens with underscores
    #
    newname="${file//[ -]/_}"

    #
    # Only rename if the name changed
    #
    if [[ "$file" != "$newname" ]]; then
      mv -- "$file" "$newname"
      echo "Renamed: '$file' -> '$newname'"
    fi
  done
}

rename_remove_trailing_underscores() {
  #
  # This function removes trailing underscores before file extensions
  # Example: Group_of_cutouts_.jpg → Group_of_cutouts.jpg
  #

  for file in *; do
    [ -f "$file" ] || continue

    #
    # Use parameter expansion with regex via 'mv'
    # to remove trailing underscore before extension
    #
    newname="$(echo "$file" | sed -E 's/_(\.[a-zA-Z0-9]+)$/\1/')"

    #
    # Only rename if changed
    #
    if [[ "$file" != "$newname" ]]; then
      mv -- "$file" "$newname"
      echo "Cleaned: '$file' -> '$newname'"
    fi
  done
}


alias rename_files='rename_spaces_to_underscores && rename_remove_trailing_underscores'




reduce_quality() {
  # Usage: reduce_quality input.jpg output.jpg 50
  # This function reduces the quality of a JPEG image.
  #
  # Arguments:
  #   $1 = input image filename
  #   $2 = output image filename
  #   $3 = quality (1–100, where 100 is best quality and 1 is highly compressed)
  #
  # Requirements:
  #   - ImageMagick must be installed (use `sudo apt install imagemagick`)
  #
  # Example:
  #   reduce_quality original.jpg reduced.jpg 40
  #   => This will compress original.jpg to 40% quality and save as reduced.jpg

  if [[ $# -ne 3 ]]; then
    echo "❌ Error: Need 3 arguments — input.jpg output.jpg quality(1-100)"
    return 1
  fi

  local input="$1"
  local output="$2"
  local quality="$3"

  # Check if input file exists
  if [[ ! -f "$input" ]]; then
    echo "❌ Error: Input file '$input' not found!"
    return 1
  fi

  # Check if quality is a number between 1 and 100
  if ! [[ "$quality" =~ ^[0-9]+$ ]] || (( quality < 1 || quality > 100 )); then
    echo "❌ Error: Quality must be a number from 1 to 100"
    return 1
  fi

  # Actual image compression command
  convert "$input" -quality "$quality" "$output"

  # Feedback
  if [[ $? -eq 0 ]]; then
    echo "✅ Image '$input' compressed to quality $quality% as '$output'"
  else
    echo "❌ Failed to compress image"
    return 1
  fi
}



reduce_to_size() {
  # Usage: reduce_to_size input.jpg output.jpg target_size_kb
  #
  # Description:
  #   Compresses the image by reducing quality until it's <= target size (in KB)
  #
  # Requirements:
  #   - ImageMagick (`convert`)
  #   - `stat` (standard in Linux)
  #
  # Arguments:
  #   $1 = input image file
  #   $2 = output image file
  #   $3 = target size in KB (e.g. 200 for 200KB)
  #
  # Example:
  #   reduce_to_size pic.jpg small.jpg 200
  #
  # Notes:
  #   - This works best on JPEG images.
  #   - The size may not match exactly; it tries best with quality steps.

  if [[ $# -ne 3 ]]; then
    echo "❌ Usage: reduce_to_size input.jpg output.jpg target_size_kb"
    return 1
  fi

  local input="$1"
  local output="$2"
  local target_kb="$3"

  if [[ ! -f "$input" ]]; then
    echo "❌ Error: Input file '$input' does not exist."
    return 1
  fi

  if ! [[ "$target_kb" =~ ^[0-9]+$ ]]; then
    echo "❌ Error: Target size must be a number in KB"
    return 1
  fi

  local quality=90
  local temp_out="__temp_compress.jpg"

  # Try reducing quality in steps until file is under target
  while (( quality >= 10 )); do
    convert "$input" -quality "$quality" "$temp_out"
    local size_kb=$(du -k "$temp_out" | cut -f1)

    if (( size_kb <= target_kb )); then
      mv "$temp_out" "$output"
      echo "✅ Compressed to ~$size_kb KB with quality=$quality → $output"
      return 0
    fi

    ((quality -= 5))  # decrease quality
  done

  echo "⚠️ Could not reduce to ${target_kb}KB. Lowest tried: quality=$quality"
  rm -f "$temp_out"
  return 1
}




join_images_side_by_side() {
  # Usage: join_images_side_by_side img1.jpg img2.jpg output.jpg
  #
  # Description:
  #   Combines two images side by side (horizontally)
  #
  # Requirements:
  #   - ImageMagick (`convert`)
  #
  # Arguments:
  #   $1 = first input image
  #   $2 = second input image
  #   $3 = output image filename
  #
  # Example:
  #   join_images_side_by_side left.jpg right.jpg joined.jpg
  #
  # Notes:
  #   - If heights of images are different, the smaller one is padded
  #   - Output format is based on the extension of $3 (e.g., .jpg, .png)

  if [[ $# -ne 2 ]]; then
    echo "❌ Usage: join_images_side_by_side img1.jpg img2.jpg output.jpg"
    return 1
  fi

  local img1="$1"
  local img2="$2"
  local output="Final_result"

  if [[ ! -f "$img1" || ! -f "$img2" ]]; then
    echo "❌ Error: One or both input files not found."
    return 1
  fi

  # Join images horizontally (side by side)
  convert "$img1" "$img2" +append "$output"

  if [[ $? -eq 0 ]]; then
    echo "✅ Images joined side by side → $output"
  else
    echo "❌ Failed to join images."
    return 1
  fi
}



#
# https://www.scribd.com/
#

change_pdf_hash_batch() {
  local infile="$1"

  # Check if input file exists
  if [[ ! -f "$infile" ]]; then
    echo "❌ File not found: $infile"
    return 1
  fi

  # Loop to create 5 output files
  for i in {1..5}; do

    # Generate a random filename like: pdf_x8kd3p2z.pdf
    local randname="pdf_$(tr -dc a-z0-9 </dev/urandom | head -c 8).pdf"

    # Copy original file to new random file
    cp "$infile" "$randname"

    # Append harmless random comment to change hash
    echo -e "\n% RandomHash: $RANDOM-$RANDOM-$RANDOM" >> "$randname"

    # Confirm created file
    echo "✅ Created: $randname"
  done
}






rename_files_nicely() {
  # Loop through all files in the current directory
  for file in *; do
    # Skip if not a regular file
    [[ -f "$file" ]] || continue

    # Extract filename without extension
    name="${file%.*}"

    # Extract file extension (includes the last dot)
    ext="${file##*.}"

    # Replace spaces, dashes, and dots inside the name
    new_name="${name// /_}"        # Replace spaces with _
    new_name="${new_name//-/_}"    # Replace - with _
    new_name="${new_name//./_}"    # Replace . (dots) with _

    # Remove multiple underscores by collapsing __ into _
    while [[ "$new_name" == *"__"* ]]; do
      new_name="${new_name//__/_}"
    done

    # Combine cleaned name with original extension
    new_file="${new_name}.${ext}"

    # Rename the file if the new name is different
    if [[ "$file" != "$new_file" ]]; then
      mv -v -- "$file" "$new_file"
    fi
  done
}



generate_img_tags() {
  # Start a <p> tag with float="left" to align images side by side (if rendered in HTML)
  echo '<p float="left">'

  # Loop through all .png and .jpg files in the current directory
  for file in *.png *.jpg; do
    # Skip if the pattern didn't match any file
    [[ -f "$file" ]] || continue

    # Print an <img> HTML tag pointing to the image inside "MechanicalParts" folder
    # The "src" attribute uses the file name
    # The width is set to 200 pixels for uniform preview
    echo "  <img src=\"MechanicalParts/${file}\" width=\"200\"/>"
  done

  # Close the paragraph tag
  echo '</p>'
}




download_all_from_url() {
  # Step 1: Store the first argument as the URL
  url="$1"

  # Step 2: Check if the URL is empty; if so, print usage and exit the function
  [ -z "$url" ] && { 
    echo "Usage: download_all_from_url <url>" 
    return 1 
  }

  # Step 3: Fetch the webpage content and extract href values (file links)
  # - curl -s: silently fetch the page
  # - grep -oP: extract only matched parts using Perl regex (-P)
  #   - '(?<=href=")[^"]+': match anything after href=" and before next "
  # - grep -vE: exclude items that start with ?, /, or #
  files=$(curl -s "$url" | grep -oP '(?<=href=")[^"]+' | grep -vE '^(\?|\/|#)' )

  # Step 4: Loop through each extracted filename
  for file in $files; do
    echo "Downloading $file..."

    # Step 5: Download the file using curl -O
    # - ${url%/}: removes trailing slash if present
    # - $file: appends the filename to the URL
    curl -O "${url%/}/$file"
  done
}



download_all_from_url_recursive() {
  local url="${1%/}"   # remove trailing slash
  local dest="${2:-.}" # optional second arg: destination folder

  [ -z "$url" ] && { echo "Usage: download_all_from_url_recursive <url> [dest_folder]"; return 1; }

  echo "Fetching: $url"
  mkdir -p "$dest"

  local items=$(curl -s "$url/" | grep -oP '(?<=href=")[^"]+' | grep -vE '^(\?|#|/)' )

  for item in $items; do
    # Skip parent dir
    [ "$item" = "../" ] && continue

    if [[ "$item" == */ ]]; then
      # Directory: recurse into it
      download_all_from_url_recursive "$url/$item" "$dest/$item"
    else
      # File: download it
      echo "Downloading: $item -> $dest/$item"
      curl -s -o "$dest/$item" "$url/$item"
    fi
  done
}



#####################
#
# Need_files_Function_START
#
######################

# This function creates a sample .gitignore file in the current directory.
# It is designed to be a quick start for new projects.

function need_file_gitignore() {
  # The 'if' statement checks if a .gitignore file already exists.
  # The '-f' flag tests for the existence of a regular file.
  if [ -f ".gitignore" ]; then
    # If the file exists, it prints an error message and exits the function with a status of 1 (failure).
    echo "Error: A .gitignore file already exists in this directory."
    return 1
  else
    # If the file does not exist, a new one is created.
    # The '>' operator redirects the output of 'echo' to the file, overwriting it.
    echo "# This is a sample .gitignore file created by 'need_file_gitignore'." > .gitignore
    echo "# You can add or remove patterns as needed for your specific project." >> .gitignore
    echo "" >> .gitignore
    
    # The '>>' operator appends the output to the file without overwriting it.
    # These lines add common patterns to ignore.
    
    # --- Project-specific files ---
    # These are commonly ignored files and directories for various languages/frameworks.
    # The trailing '/' on 'node_modules/' and 'dist/' indicates a directory.
    echo "# Commonly ignored directories" >> .gitignore
    echo "node_modules/" >> .gitignore
    echo "dist/" >> .gitignore
    echo "build/" >> .gitignore
    echo "" >> .gitignore
    
    # --- Operating System & Editor Files ---
    # Many operating systems and editors create temporary or configuration files.
    # The '*' is a wildcard that matches any characters. For example, '*.log' ignores any file ending in '.log'.
    echo "# Operating System & Editor files" >> .gitignore
    echo "*.DS_Store" >> .gitignore
    echo "*.log" >> .gitignore
    echo "*.swp" >> .gitignore
    echo ".vscode/" >> .gitignore
    echo "" >> .gitignore

    # --- Sensitive information and environment files ---
    # This is a critical one. Never commit your secrets!
    # A single dot at the beginning of a file name, like '.env', indicates a hidden file.
    echo "# Sensitive files and environment variables" >> .gitignore
    echo ".env" >> .gitignore
    echo "*.env.local" >> .gitignore
    echo "" >> .gitignore
    
    # --- Python-specific files ---
    # This section is an example of language-specific ignores.
    echo "# Python-specific ignores" >> .gitignore
    echo "__pycache__/" >> .gitignore
    echo "*.pyc" >> .gitignore
    echo "" >> .gitignore

    # The function prints a success message and returns 0 (success).
    echo "Successfully created a new .gitignore file in the current directory."
    return 0
  fi
}


# This function creates a simple C++ "Hello, World!" file.
# If 'main.cpp' already exists, it will create 'main_1.cpp', 'main_2.cpp', and so on.

function need_file_cpp_sample() {
  # Initialize the base filename and a counter for new files.
  local filename="main.cpp"
  local counter=0

  # This loop checks for the existence of 'filename'.
  # The '-f' flag tests for a regular file.
  # The loop continues as long as a file with the current name exists.
  while [ -f "$filename" ]; do
    # If the file exists, it prints a message and increments the counter.
    echo "Info: File '$filename' already exists. Trying a new name..."
    ((counter++))
    # It then constructs a new filename, like 'main_1.cpp', 'main_2.cpp', etc.
    filename="main_${counter}.cpp"
  done

  # Once an available filename is found, the script creates the file.
  # The '>' operator redirects the following output into the new file.
  echo "// A simple C++ program created by 'need_file_cpp_sample'" > "$filename"
  echo "#include <iostream>" >> "$filename"
  echo "" >> "$filename"
  echo "int main() {" >> "$filename"
  echo "    // Print a message to the console." >> "$filename"
  echo "    std::cout << \"Hello, World!\" << std::endl;" >> "$filename"
  echo "    return 0;" >> "$filename"
  echo "}" >> "$filename"

  # The function prints a success message and returns 0 (success).
  echo "Successfully created a new C++ sample file: '$filename'"
  return 0
}

# This function prints a guide on best practices for naming C++ libraries.
# It can be used as a quick reference for yourself.

function print_cpp_naming_guide() {
  echo "A good C++ library name should be descriptive and consistent. Here are three examples with a brief explanation for each:"
  echo ""
  echo "graphics_utils: This is a great choice for a library containing utility functions for handling graphics, such as drawing shapes or managing colors."
  echo "crypto_lib: A clear and concise name for a library that provides cryptographic functions like encryption and hashing."
  echo "network_tools: This name is perfect for a library containing various functions for network operations, such as making API requests or handling network connections."
  echo ""
  echo "Each of these names is descriptive and uses snake_case, which is a common and recommended convention for C++ libraries. This helps ensure the library is easy to identify and use."
}



function need_file_cpp_library() {
#help for naming_guide
  print_cpp_naming_guide
  read -p "Please enter the library name: " library_name
  if [ -z "$library_name" ]; then
    echo "Error: Library name cannot be empty."
    return 1
  fi

  # Sanitize name for C++ identifiers
  local clean_name=$(echo "$library_name" | tr -cd '[:alnum:]_')
  local include_guard=$(echo "${clean_name}_HPP" | tr '[:lower:]' '[:upper:]')

  mkdir -p "$library_name/include" "$library_name/src"

  local header_file="$library_name/include/${clean_name}.hpp"
  local source_file="$library_name/src/${clean_name}.cpp"

  cat <<EOF > "$header_file"
#ifndef ${include_guard}
#define ${include_guard}

// This is a basic C++ library header file.

namespace ${clean_name} {

// Function to add two integers.
int add(int a, int b);

}

#endif // ${include_guard}
EOF

  cat <<EOF > "$source_file"
// This is the source file for the ${clean_name} library.
#include "${clean_name}.hpp"

namespace ${clean_name} {

// Definition of the 'add' function.
int add(int a, int b) {
  return a + b;
}

}
EOF

  echo "Successfully created library files:"
  echo "- Header: $header_file"
  echo "- Source: $source_file"
}



# This function creates a study folder with a .md and .cpp file.
# Usage example:
#   need_files_for_study vector
# This will create:
#   vector/
#       vector.md
#       vector.cpp

need_files_for_study() {
    # "$1" is the first argument passed to the function.
    # Example: if you run `need_files_for_study vector`,
    # then $1 will be "vector".
    local topic="$1"

    # Check if the user provided an argument.
    if [ -z "$topic" ]; then
        echo "Error: You must provide a topic name."
        echo "Example: need_files_for_study vector"
        return 1
    fi

    # Create the directory for the topic.
    # -p means it won't complain if it already exists.
    mkdir -p "$topic"

    # Create an empty .md file for study notes.
    touch "$topic/${topic}.md"

    # Create an empty .cpp file for code examples.
    touch "$topic/${topic}.cpp"

    # Print a success message.
    echo "Created study files inside '$topic/'"
    echo "- $topic/${topic}.md"
    echo "- $topic/${topic}.cpp"
}




#####################
#
# Need_files_Function_END
#
######################


check_and_fix_json() {
    file="$1"

    # First, check JSON validity
    if jq empty "$file" >/dev/null 2>err.log; then
        echo "✅ JSON is valid: $file"
        return 0
    else
        echo "❌ JSON is invalid: $file"
        echo "Error details:"
        cat err.log
    fi

    # Try to auto-fix using jsonlint (npm install -g jsonlint)
    if command -v jsonlint >/dev/null; then
        echo "🔧 Attempting auto-fix..."
        jsonlint --in-place "$file" 2>/tmp/fix_err.log
        if [ $? -eq 0 ]; then
            echo "✅ JSON fixed and saved: $file"
        else
            echo "❌ Auto-fix failed:"
            cat /tmp/fix_err.log
        fi
    else
        echo "💡 Install jsonlint for auto-fixing: npm install -g jsonlint"
    fi
}


