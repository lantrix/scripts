#!/bin/bash
# Move images to folders with YYYY-MM in them
for x in *.jpg; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done
for x in *.JPG; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done
for x in *.mov; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done
for x in *.MOV; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done
for x in *.mp4; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done
for x in *.MP4; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done
for x in *.AAE; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done
