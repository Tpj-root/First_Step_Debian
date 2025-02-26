#!/bin/bash
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

test() {
    echo "Script Name: ${BASH_SOURCE[0]}"
}

lc() {
    test
}
