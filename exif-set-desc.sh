#!/bin/bash

# ExifTool set Image Description in a photo

command -v exiftool >/dev/null 2>&1 || { echo >&2 "I require exiftool but it's not installed. Aborting."; exit 1; }

if [ ! -n "$1" ]; then
    echo "Usage: `basename $0` 'My Image description' 0002.jpg"
    exit
fi

# Inputs & Params for script
description=${1?param missing - ImageDescription}
filename=${2?param missing - filename}

if [ $# -gt 2 ]; then
    exitWithErrorMessage "$0: too many arguments"
fi

ls "${filename}" >/dev/null 2>&1
if ! [ "$?" = "0" ]; then
	echo >&2 "I can't find $filename. Aborting."; exit 1;
fi

exiftool -overwrite_original -preserve "-ImageDescription=${description}" "$filename"
exiftool -G0:1 -s -n -ImageDescription "$filename"
