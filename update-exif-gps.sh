#!/bin/bash

# ExifTool set GPS co-oords in a photo

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` 0002.jpg 36.989213 -84.231474"
	echo "Lat/Long must be in Decimal Degrees (DD)"
    exit
fi

# Inputs & Params for script
latitude=${2?param missing - latitude}
longtitude=${3?param missing - longtitude}

if [ $# -gt 3 ]; then
    exitWithErrorMessage "$0: too many arguments"
fi

ls ${1} >/dev/null 2>&1
if ! [ "$?" = "0" ]; then
	echo >&2 "I can't find $1. Aborting."; exit 1;
fi

re='^-?[0-9]+([.][0-9]+)?$'

if ! [[ $latitude =~ $re ]] ; then
   echo >&2 "Latitude: $latitude is not a valid Decimal Degrees. Aborting."; exit 1;
fi

if ! [[ $longtitude =~ $re ]] ; then
   echo >&2 "Longtitude: $longtitude is not a valid Decimal Degrees. Aborting."; exit 1;
fi

exiftool -overwrite_original -XMP:GPSLatitude=${latitude} -XMP:GPSLongitude=${longtitude} -P $1
exiftool $1 |grep -i gps
