#!/bin/bash

check_new_packages() {
    if [[ ! -f "$HOME/Desktop/MY_GIT/First_Step_Debian/24-02-2025_day_1st.txt" ]]; then
        echo "Error: Old package list not found!"
        return 1
    fi

    comm -13 <(awk '{print $2}' "$HOME/Desktop/MY_GIT/First_Step_Debian/24-02-2025_day_1st.txt" | sort) \
             <(dpkg -l | awk '{print $2}' | sort)
}

check_new_packages
#alias dpkg_update='check_new_packages'


