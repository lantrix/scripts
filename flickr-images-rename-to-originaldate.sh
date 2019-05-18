#!/bin/bash
# When you download a zip of images from flickr, the files are named by flickr object IDs.
# Processing all files in a directory, this script will:
#  - Change OS Modify date to match the EXIF OriginalDate of the image
#  - Rename image to match EXIF OriginalDate in format:
#      YYYY-MM-DD HH:mm:ss.ext

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` /path/to/images/folder"
    exit
fi

DIR="$1"

# failsafe - fall back to current directory
[ "$DIR" == "" ] && DIR="."

# save and change IFS
OLDIFS=$IFS
IFS=$'\n'

# read all file name into an array
fileArray=($(find $DIR -type f))

# restore it
IFS=$OLDIFS

# get length of an array
tLen=${#fileArray[@]}
echo "Number of files $tLen"

# use for loop read all filenames
for (( i=0; i<${tLen}; i++ ));
do
	thisFile=${fileArray[$i]}
	fileType=$(file -b -I ${fileArray[$i]})
	if ! [[ $fileType == *"image"* ]]; then
		echo "$thisFile is not an image ... skipping"
		continue
	fi
	exiftool "${fileArray[$i]}" -ExifIFD:DateTimeOriginal
	
	echo -n "$thisFile "
	#change file OS modify date
	exiftool -overwrite_original '-FileModifyDate<DateTimeOriginal' "${fileArray[$i]}"
	#rename file
	exiftool '-FileName<DateTimeOriginal' -d "%Y-%m-%d %H.%M.%S%%-c.%%e" "${fileArray[$i]}"
done
