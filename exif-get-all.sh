#!/bin/bash
# Display Exif GPS Data

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

function viewGPS() {
  local file=$1
  echo "Viewing all EXIF GPS data for $file"
  echo

  exiftool -G0:1 -s -n -GPS* "$file"

  lat=$(exiftool -s3 -GPSLatitude -n $file)
  long=$(exiftool -s3 -GPSLongitude -n $file)

  if [[ ! -z "$lat" && ! -z "$long" ]] ; then
    URL="https://www.google.com/maps?q=${lat},${long}"
    echo
    echo "Google Maps link"
    echo $URL
	  echo
  fi
}

function viewDESC() {
  local file=$1
	echo "Viewing all EXIF Description for $file"
	echo

	exiftool -G0:1 -s -n -ImageDescription "$file"
	echo
}

function viewDATES() {
  local file=$1
	echo "Viewing all EXIF time data for $file"
	echo

	exiftool -time:all -a -G0:1 -s "$file"
	echo
}


#Count input files (for wildcards)
count="$#" #Parent shell expands wildcard - handle as array
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
			viewDESC $thisFile
			viewDATES $thisFile
			viewGPS $thisFile
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
			viewDESC $input
			viewDATES $input
			viewGPS $input
		fi
	fi
fi

