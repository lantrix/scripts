#!/bin/bash -e
# Display Exif Dates for custom photos scanned (TIFF and RAW)

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` image_number"
    exit
fi

imageNumber="$1"
original=($HOME/Pictures/original-scans/*${imageNumber}*)
raw=($HOME/Pictures/vuescan-raw/*${imageNumber}*)

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

fileType=$(file -b -I ${original})
if ! [[ $fileType == *"image"* ]]; then
  echo "${original} is not an image ... skipping"
else
  echo
  echo "Viewing all EXIF time data for ${original}"
  echo

  exiftool -time:all -a -G0:1 -s "${original}"
fi

fileType=$(file -b -I ${raw})
if ! [[ $fileType == *"image"* ]]; then
  echo "${raw} is not an image ... skipping"
else
  echo
  echo "Viewing all EXIF time data for ${raw}"
  echo

  exiftool -time:all -a -G0:1 -s "${raw}"
fi
