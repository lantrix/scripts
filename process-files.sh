#!/bin/bash
# Processing filenames using an array - from https://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html

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
 
# use for loop read all filenames
for (( i=0; i<${tLen}; i++ ));
do
  echo "${fileArray[$i]}"
done