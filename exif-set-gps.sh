#!/bin/bash

# ExifTool set GPS co-oords in a photo

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` 36.989213 -84.231474 0002.jpg"
	echo "Lat/Long must be in Decimal Degrees (DD)"
    exit
fi

# Inputs & Params for script
latitude=${1?param missing - latitude}
longtitude=${2?param missing - longtitude}
filename=${3?param missing - filename}

if [ $# -gt 3 ]; then
    echo "$0: too many arguments"
    exit 1
fi

ls "${filename}" >/dev/null 2>&1
if ! [ "$?" = "0" ]; then
	echo >&2 "I can't find $filename. Aborting."; exit 1;
fi

re='^-?[0-9]+([.][0-9]+)?$'

if ! [[ $latitude =~ $re ]] ; then
   echo >&2 "Latitude: $latitude is not a valid Decimal Degrees. Aborting."; exit 1;
fi

if ! [[ $longtitude =~ $re ]] ; then
   echo >&2 "Longtitude: $longtitude is not a valid Decimal Degrees. Aborting."; exit 1;
fi

exiftool -overwrite_original -preserve -XMP:GPSLatitude=${latitude} -XMP:GPSLongitude=${longtitude} -P "$filename"
exiftool -a -G0:1 -s -n -GPS* "$filename"
