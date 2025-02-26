#!/bin/bash

# UTF-8 is the encoding that supports all Unicode characters, 
# but displaying emojis depends on the installed font. 
# Not all fonts include all Unicode characters, especially emojis.

# cnc@debian:~$ fc-list | grep -i emoji
# /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf: Noto Color Emoji:style=Regular

print_unicode_range() {
    local start=$1
    local end=$2
    local column_count=$3

    for ((i=start; i<=end; i++)); do
        printf "U+%04X: \U$(printf "%08x" $i)\n" "$i"  # Print Unicode and emoji
    done
    echo
}

echo "😀 Emoticons (U+1F600 to U+1F64F)"
print_unicode_range 0x1F600 0x1F64F 1

echo "🔣 Dingbats (U+2700 to U+27BF)"
print_unicode_range 0x2700 0x27BF 1

echo "🚗 Transport & Map Symbols (U+1F680 to U+1F6FF)"
print_unicode_range 0x1F680 0x1F6FF 1

echo "🎭 Miscellaneous Symbols (U+2600 to U+26FF)"
print_unicode_range 0x2600 0x26FF 1

echo "🌀 Symbols & Pictographs (U+1F300 to U+1F5FF)"
print_unicode_range 0x1F300 0x1F5FF 1

echo "🤖 Supplemental Symbols & Pictographs (U+1F900 to U+1F9FF)"
print_unicode_range 0x1F900 0x1F9FF 1

echo "🩻 Extended Symbols & Pictographs (U+1FA70 to U+1FAFF)"
print_unicode_range 0x1FA70 0x1FAFF 1
