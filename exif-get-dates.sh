#!/bin/bash -e
# Display Exif Dates

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` /path/to/image.jpg"
    exit
fi

#Count input files (for wildcards)
count=$# #Parent shell expands wildcard - handle as array

input="$@"

if [ "$count" -gt 1 ]; then

	# get length of an array
	echo "Number of files $#"

	# use for loop read all filenames
	for thisFile in "${@}";
	do
		fileType=$(file -b -I ${thisFile})
		if ! [[ $fileType == *"image"* ]]; then
			echo "$thisFile is not an image ... skipping"
			continue
		fi
		echo "Viewing all EXIF time data for $thisFile"
		echo

		exiftool -time:all -a -G0:1 -s "$thisFile"
		echo
	done
elif [ "$count" -eq 1 ]; then
	if [ $(find $input | wc -l) -ne 1 ]; then
		echo "No matching files"
		exit 1
	else
		fileType=$(file -b -I ${input})
		if ! [[ $fileType == *"image"* ]]; then
			echo "$thisFile is not an image ... skipping"
		else
			echo "Viewing all EXIF time data for $input"
			echo

			exiftool -time:all -a -G0:1 -s "$input"
		fi
	fi
fi

