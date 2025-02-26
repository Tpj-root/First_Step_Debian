#!/bin/bash

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