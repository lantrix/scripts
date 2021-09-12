#!/bin/bash -e
# Display Exif Dates

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` /path/to/image.jpg"
    exit
fi

testIfImage() {
  local file=$1
	local flag=0
  fileType=$(file -b -I ${file})
  if ! [[ $fileType == *"image"* ]]; then flag=1; fi
	return $flag
}

function viewData() {
  local file=$1
	echo "Viewing all EXIF time data for $file"
	echo

	exiftool -time:all -a -G0:1 -s "$file"
	echo
}

#Count input files (for wildcards)
count=$# #Parent shell expands wildcard - handle as array
input="$@"

if [ "$count" -gt 1 ]; then

	# get length of an array
	echo "Number of files $#"
	# use for loop read all filenames
	for thisFile in "${@}";
	do
		testIfImage $thisFile
		if [[ $? -ne 0 ]]; then 
			echo "$thisFile is not an image ... skipping"
			echo
		else
			viewData $thisFile
		fi

	done
elif [ "$count" -eq 1 ]; then
	if [ $(find $input | wc -l) -ne 1 ]; then
		echo "No matching files"
		exit 1
	else
		testIfImage $input
		if [[ $? -ne 0 ]]; then 
			echo "$input is not an image ... skipping"
			echo
		else
			echo "image found"
			viewData $input
		fi
	fi
fi

