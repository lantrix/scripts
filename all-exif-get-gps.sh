#!/bin/bash -e
# Display Exif GPS Data for custom photos scanned (TIFF and RAW)

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
  echo "Found Original"
  echo "Viewing all EXIF GPS data for ${original}"
  echo

  exiftool -G0:1 -s -n -GPS* "${original}"

  lat=$(exiftool -s3 -GPSLatitude -n ${original})
  long=$(exiftool -s3 -GPSLongitude -n ${original})

  if [[ ! -z "$lat" && ! -z "$long" ]] ; then
    URL="https://www.google.com/maps?q=${lat},${long}"
    echo
    echo "Google Maps link"
    echo $URL
    echo
  fi
fi

fileType=$(file -b -I ${raw})
if ! [[ $fileType == *"image"* ]]; then
  echo "${raw} is not an image ... skipping"
else
  echo
  echo "Found Raw"
  echo "Viewing all EXIF GPS data for ${raw}"
  echo

  exiftool -G0:1 -s -n -GPS* "${raw}"

  lat=$(exiftool -s3 -GPSLatitude -n ${raw})
  long=$(exiftool -s3 -GPSLongitude -n ${raw})

  if [[ ! -z "$lat" && ! -z "$long" ]] ; then
    URL="https://www.google.com/maps?q=${lat},${long}"
    echo
    echo "Google Maps link"
    echo $URL
    echo
  fi
fi