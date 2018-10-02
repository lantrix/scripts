#!/bin/bash
# Move images to folders with YYYY-MM in them
for x in *.jpg; do d=$(date -r "$x" +%Y-%m) ; mkdir -p "$d"; mv -- "$x" "$d/"; done