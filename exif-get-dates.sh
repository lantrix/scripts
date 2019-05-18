#!/bin/bash
# Display Exif Dates

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` /path/to/image.jpg"
    exit
fi

echo "Viewing all EXIF time data for ${1}"
exiftool -time:all -a -G0:1 -s "${1}"
