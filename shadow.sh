#!/bin/bash
#
# 
#
version="1.0"

# Function to print the welcome message
showmesg() {
    echo "welcome $1"
}

# Function to handle the 'help' command
help_command() {
    print_random_color "Help Message:"
    print_random_color "Type 'shadow' to start."
    print_random_color "Type 'help' to show this message."
    print_random_color "Type 'clear' to clear the screen."
    print_random_color "Type 'exit' to quit the shell."
    print_random_color "You can run any Linux command."
}

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Array of color codes
colors=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$MAGENTA" "$CYAN")
# colors=("$GREEN")

# Function to print colored text in a random color
print_error_color() {
    local message=$1
    local random_color=${RED}
    echo -e "${random_color}${message}${RESET}"
}

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
echo -e ${GREEN} "The reason to start is to pave the way for the possibilities that lie ahead."
}


# These are outside the while true loop so they run only once when the script starts.
title_fun
why


# new terminal open and run the any command function
# xterm -hold -e "seq 1 100" &

# Set Window Size and Position
# xterm -geometry 80x24+100+100 &

# Turtle emoji
# echo -e "Turtle emoji: $(echo -e "\U1F422")"
# list the emoji
# seq 01 999 | while read line; do echo -e "\U1F$line"; done | column 

# figlet online https://www.askapache.com/online-tools/figlet-ascii/


open_new_terminal() {
#    xterm -geometry 100x30+200+150 -hold -e "seq 1 1000" &
    xterm -geometry 100x30+400+350  -e "seq 1 10000" &
    xterm -geometry 100x30+600+550  -e "seq 1 10000" &
    xterm -geometry 100x30+800+750  -e "seq 1 10000" &
}



emoji() {
    local message="$1"
    local output=""

    declare -A emoji_map=(
        ["a"]="🅐 "
        ["b"]="🅑 "
        ["c"]="🅒 "
        ["d"]="🅓 "
        ["e"]="🅔 "
        ["f"]="🅕 "
        ["g"]="🅖 "
        ["h"]="🅗 "
        ["i"]="🅘 "
        ["j"]="🅙 "
        ["k"]="🅚 "
        ["l"]="🅛 "
        ["m"]="🅜 "
        ["n"]="🅝 "
        ["o"]="🅞 "
        ["p"]="🅟 "
        ["q"]="🅠 "
        ["r"]="🅡 "
        ["s"]="🅢 "
        ["t"]="🅣 "
        ["u"]="🅤 "
        ["v"]="🅥 "
        ["w"]="🅦 "
        ["x"]="🅧 "
        ["y"]="🅨 "
        ["z"]="🅩 "
    )

    for (( i=0; i<${#message}; i++ )); do
        char="${message:$i:1}"
        # Convert to lowercase if it's an uppercase letter
        char_lower=$(echo "$char" | tr '[:upper:]' '[:lower:]')
        if [[ -n "${emoji_map[$char_lower]}" ]]; then
            output+="${emoji_map[$char_lower]}"
        else
            output+="$char"
        fi
    done

    echo "$output"
}

# Usage example




# Main shell loop
while true; do
    # Prompt for user input
    read -p "🅂 🅷 🅰 🅳 🅾 🆆 @ bash 🡆 💀" input

    # Process user commands
    case $input in
        shadow)
            # If user types 'shadow', display the welcome message
            showmesg "shadow"
            ;;
        help)
            # If user types 'help', display the help message
            help_command
            ;;
        clear)
            # If user types 'clear', clear the terminal
            clear
            ;;
        seq)
            # testing
            open_new_terminal
            ;;
        hello)
            # testing
            emoji "hello"
            ;;
        exit)
            # Exit the custom shell
            echo "Exiting..."
            cowsay "bye bye..."
            break
            ;;
        :q)
            # Exit the custom shell
            echo "Exiting... "
            cowsay "bye bye..."
            break
            ;;
        *)
            # If the command is not one of the custom commands, try to execute it as a Linux command
            eval "$input" 2>/dev/null || print_error_color "Unknown command: $input"
            ;;
    esac
done

