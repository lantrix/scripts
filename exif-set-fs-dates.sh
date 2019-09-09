#!/bin/bash

# Will set Exif and FS dates for:

# - the DateTimeOriginal
# - The File System Create Date/Time
# - The File System Modification Date/Time

# EXIF Specs mapped to EXIF tags used by exiftool
# http://www.exiv2.org/tags.html
# https://sno.phy.queensu.ca/~phil/exiftool/TagNames/EXIF.html
#
# TAG:  0x0132  ModifyDate  string  IFD0    (called DateTime by the EXIF spec.)
# SPEC: 0x0132  306 Image   Exif.Image.DateTime Ascii   The date and time of image creation. In Exif standard, it is the date and time the file was changed.
#
# TAG:  0x9004  CreateDate  string  ExifIFD (called DateTimeDigitized by the EXIF spec.)
# SPEC: 0x9004  36868   Photo   Exif.Photo.DateTimeDigitized    Ascii   The date and time when the image was stored as digital data.
#
# TAG:  0x9003  DateTimeOriginal    string  ExifIFD (date/time when original image was taken)
# SPEC: 0x9003  36867   Image   Exif.Image.DateTimeOriginal Ascii   The date and time when the original image data was generated.
#
# ExifTool also allows FileModifyDate to be written, which provides full control over the filesystem modification date/time when writing

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
        echo "Usage: `basename $0` 2018-01-01 12:00:00 Day1_20150102_161309_00002.jpg"
        echo
        exit
fi

# Inputs & Params for script
date=${1?param missing - Date}
time=${2?param missing - Time}
filename=${3?param missing - Filename}

# Check for filename.
if ! [[ -f "${filename}" ]]; then
    echo >&2 "I can't find ${filename}. Aborting."; exit 1;
fi

newDateTime="${date} ${time}"

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
echo "Processing ${filename}"
exifDateTime=${newDateTime//-/:}
#Set DateTimeOriginal
exiftool -overwrite_original -DateTimeOriginal="${exifDateTime}" "$filename"
#change file Create Date
exiftool -q -overwrite_original '-CreateDate<DateTimeOriginal' "$filename"
#change file OS modify date
exiftool -q -overwrite_original '-FileModifyDate<DateTimeOriginal' "$filename"
exiftool -time:all -a -G0:1 -s "$filename"
