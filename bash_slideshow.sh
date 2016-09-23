#!/bin/bash

trap 'reset; exit' INT

files=("$@")

tput civis

i=0
while [ $i -lt ${#files[@]} ]; do

    clear

    # Print [ slide / total ] in top right
    tput sc
    slide="[$((i+1))/${#files[@]}]"
    x=$(( $(tput cols) - ${#slide} - 1))
    tput cup 0 $x
    echo -e "\e[90m$slide\e[0m"
    tput rc

    # Print slide
    echo -e "$(cat ${files[$i]})"

    # Read from keyboard
    extension="${files[$i]##*.}"
    [[ $extension =~ t[0-9]* ]] && timeout="-$extension" || timeout=""
    read $timeout -n1 c

    # Process keyboard
    case $c in
        ['qQ'])
            break
            ;;
        ['<'])
            (( i = i - (i > 0) ))
            continue
            ;;
    esac

    # Next slide
    (( i = i + 1 ))
done

tput cnorm
