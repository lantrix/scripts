#!/bin/bash

# ExifTool set GPS co-oords in all custom photos scanned (TIFF and RAW)

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` 36.989213 -84.231474 image_number"
    echo "Lat/Long must be in Decimal Degrees (DD)"
    exit
fi

# Inputs & Params for script
latitude=${1?param missing - latitude}
longtitude=${2?param missing - longtitude}
imageNumber=${3?param missing - filename}
original=($HOME/Pictures/original-scans/*${imageNumber}*)
raw=($HOME/Pictures/vuescan-raw/*${imageNumber}*)

if [ $# -gt 3 ]; then
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

#Strip leading or trailing commas from GPS Coords
latitude=$(echo $latitude |sed 's/^,*//;s/,*$//')
longtitude=$(echo $longtitude |sed 's/^,*//;s/,*$//')

re='^-?[0-9]+([.][0-9]+)?$'

if ! [[ $latitude =~ $re ]] ; then
   echo >&2 "Latitude: $latitude is not a valid Decimal Degrees. Aborting."; exit 1;
fi

if ! [[ $longtitude =~ $re ]] ; then
   echo >&2 "Longtitude: $longtitude is not a valid Decimal Degrees. Aborting."; exit 1;
fi

echo
echo "Setting EXIF GPS data for ${original}"
exiftool -overwrite_original -preserve -XMP:GPSLatitude=${latitude} -XMP:GPSLongitude=${longtitude} -P "${original}"
exiftool -a -G0:1 -s -n -GPS* "${original}"

echo
echo "Setting EXIF GPS data for ${raw}"
exiftool -overwrite_original -preserve -XMP:GPSLatitude=${latitude} -XMP:GPSLongitude=${longtitude} -P "${raw}"
exiftool -a -G0:1 -s -n -GPS* "${raw}"
