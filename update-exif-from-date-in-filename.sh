#!/bin/bash

# For Camera Photos that need the following fix:

# - the DateTimeOriginal was in the filename (the actual time you want as Exif.Image.DateTimeOriginal, and File System Modification Date/Time)
# - The File System Modification Date/Time is wrong
# - the Exif.Image.DateTime was never set or was wrong
# - the Exif.Photo.DateTimeDigitized was never set or was wrong
# - the Exif.Image.DateTime was never set but exists in the MetadataDate

# Format of the filename we expect to retrieve metadata from:
#
#    <text>_YYYYMMDD_HHMMSS_<sequence>.<image-extension>
#

# EXIF Specs mapped to EXIF tags used by exiftool
# http://www.exiv2.org/tags.html
# https://sno.phy.queensu.ca/~phil/exiftool/TagNames/EXIF.html
#
# TAG:  0x0132	ModifyDate	string	IFD0	(called DateTime by the EXIF spec.)
# SPEC: 0x0132	306	Image	Exif.Image.DateTime	Ascii	The date and time of image creation. In Exif standard, it is the date and time the file was changed.
#
# TAG:  0x9004	CreateDate	string	ExifIFD	(called DateTimeDigitized by the EXIF spec.)
# SPEC: 0x9004	36868	Photo	Exif.Photo.DateTimeDigitized	Ascii	The date and time when the image was stored as digital data.
#
# TAG:  0x9003	DateTimeOriginal	string	ExifIFD	(date/time when original image was taken)
# SPEC: 0x9003	36867	Image	Exif.Image.DateTimeOriginal	Ascii	The date and time when the original image data was generated.
#
# ExifTool also allows FileModifyDate to be written, which provides full control over the filesystem modification date/time when writing

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
        echo "Usage: update-exif.sh Day1_20150102_161309_00002.jpg"
        echo
        exit
fi

# Check for filename. Must be in current working directory.
filename=`basename $1`
ls "${filename}" >/dev/null 2>&1
if ! [ "$?" = "0" ]; then
	echo >&2 "I require $filename to be in the current working directory. Aborting."; exit 1;
fi

IFS="."
tab=($filename)
reconstructOriginalDate=${tab[0]}
reconstructOriginalDate=`echo $reconstructOriginalDate | sed -e 's/^.*?2015/2015/'`
reconstructOriginalDate=`echo $reconstructOriginalDate | sed -e 's/_.....$//'`
# 1986:11:05 12:00:00
reconstructOriginalDate=`echo $reconstructOriginalDate | sed -e 's/\(....\)\(..\)\(..\)_\(..\)\(..\)\(..\)/\1:\2:\3 \4:\5:\6/'`
unset IFS

metaDataDate=$(exiftool -s -s -s ${filename} -MetadataDate)

exiftool -overwrite_original -CreateDate="${reconstructOriginalDate}" -DateTimeOriginal="${reconstructOriginalDate}" -ModifyDate="${metaDataDate}" $filename
exiftool -overwrite_original '-FileModifyDate<DateTimeOriginal' $filename
