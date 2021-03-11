#!/bin/bash

# ExifTool set Image Description in all custom photos scanned (TIFF and RAW)

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` 'My Image description' image_number"
    exit
fi

# Inputs & Params for script
description=${1?param missing - ImageDescription}
imageNumber=${2?param missing - filename}
original=($HOME/Pictures/original-scans/*${imageNumber}*)
raw=($HOME/Pictures/vuescan-raw/*${imageNumber}*)

if [ $# -gt 2 ]; then
    echo "$0: too many arguments"
    exit 1
fi

ls "${original}" >/dev/null 2>&1
if ! [ "$?" = "0" ]; then
	echo >&2 "I can't find Original with image number $imageNumber. Aborting."; exit 1;
fi
echo "Found Original"

ls "${raw}" >/dev/null 2>&1
if ! [ "$?" = "0" ]; then
	echo >&2 "I can't find Raw with image number $imageNumber. Aborting."; exit 1;
fi
echo "Found Raw"

echo
echo "Setting EXIF ImageDescription data for ${original}"
exiftool -overwrite_original -preserve "-ImageDescription=${description}" "${original}"
exiftool -G0:1 -s -n -ImageDescription "${original}"

echo
echo "Setting EXIF ImageDescription data for ${raw}"
exiftool -overwrite_original -preserve "-ImageDescription=${description}" "${raw}"
exiftool -G0:1 -s -n -ImageDescription "${raw}"

