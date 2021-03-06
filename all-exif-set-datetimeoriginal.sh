#!/bin/bash

# From my LS-4000 scanned  custom photos scanned (TIFF and RAW) will set Exif dates for:

# - the DateTimeOriginal

# EXIF Specs mapped to EXIF tags used by exiftool
# http://www.exiv2.org/tags.html
# https://sno.phy.queensu.ca/~phil/exiftool/TagNames/EXIF.html
#
#
# TAG:  0x9003  DateTimeOriginal    string  ExifIFD (date/time when original image was taken)
# SPEC: 0x9003  36867   Image   Exif.Image.DateTimeOriginal Ascii   The date and time when the original image data was generated.

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` 2018:01:01 12:00:00 image_number"
    echo
    exit
fi

# Inputs & Params for script
date=${1?param missing - Date}
time=${2?param missing - Time}
imageNumber=${3?param missing - filename}
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

dateWithDash=${date//:/-}
newDateTime="${dateWithDash} ${time}"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Validate the date on a Linux machine (Redhat or Debian).  On Linux, this is
    # as easy as adding one minute and checking the return code.  If one minute
    # cannot be added, then the starting value is not a valid date/time.
    date -d "$newDateTime UTC + 1 min" +"%F %T" &> /dev/null
    test $? -eq 0 || echo >&2 "'$newDateTime' is an INVALID date/time value. Aborting" && exit 1
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Validate the date on a Mac (OSX).  This is done by adding and subtracting
    # one minute from the given date/time.  If the resulting date/time string is identical
    # to the given date/time string, then the given date/time is valid.  If not, then the
    # given date/time is invalid.
    TEST_DATETIME=$(date -v+1M -v-1M -jf "%F %T" "$newDateTime" +"%F %T" 2> /dev/null)

    if [[ "$TEST_DATETIME" != "$newDateTime" ]]; then
        echo >&2 "'$newDateTime' is an INVALID date/time value. Aborting"; exit 1
    else
        echo "'$newDateTime' is VALID"
    fi
fi

newDateTime="${date} ${time}"

echo
echo "Setting EXIF DateTimeOriginal for ${original}"
exiftool -overwrite_original -preserve -DateTimeOriginal="${newDateTime}" "${original}"
exiftool -time:all -a -G0:1 -s "${original}"

echo
echo "Setting EXIF DateTimeOriginal for ${raw}"
exiftool -overwrite_original -preserve -DateTimeOriginal="${newDateTime}" "${raw}"
exiftool -time:all -a -G0:1 -s "${raw}"
