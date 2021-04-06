#!/bin/bash
outputFile='/tmp/_scanned_photo_index_raw.csv'
# Header
echo "Outputting to: ${outputFile}"
echo "Photo ID,Filename,Date,Create (Scan) Date,Type,Resolution DPI,ImageSize,Megapixels,GPSLatitude,GPSLongitude,GPSPosition,ImageWidth,ImageHeight,FileSize,Album,Box,Custodian,Location,Metadata updated,Notes" > ${outputFile}
# Data
for photo in `ls -art |grep tif |grep -v reverse`; do
  echo "Parsing $photo"
  human=$(exiftool -f -d "%Y/%m/%d" -p '$Filename;$DateTimeOriginal;$CreateDate;$FileType;$XResolution;$ImageSize;$Megapixels;$GPSLatitude;$GPSLongitude;$GPSPosition;$ImageWidth;$ImageHeight;$FileSize;$ImageDescription' $photo)
  numeric=$(exiftool -n -f -d "%Y/%m/%d" -p '$Filename;$DateTimeOriginal;$CreateDate;$FileType;$XResolution;$ImageSize;$Megapixels;$GPSLatitude;$GPSLongitude;$GPSPosition;$ImageWidth;$ImageHeight;$FileSize;$ImageDescription' $photo)
  # Photo ID
  regex='^.*([0-9][0-9][0-9][0-9][0-9])\.tif'
  if [[ $photo =~ $regex ]]; then
    echo -n "'${BASH_REMATCH[1]}," >> ${outputFile}
  else
    echo -n "'00000," >> ${outputFile}
  fi
  
  #Filename
  field=$(echo $human | awk -F ';' '{print $1}')
  echo -n "$field;" >> ${outputFile}
  #DateTimeOriginal
  field=$(echo $human | awk -F ';' '{print $2}')
  echo -n "$field;" >> ${outputFile}
  #CreateDate
  field=$(echo $human | awk -F ';' '{print $3}')
  echo -n "$field;" >> ${outputFile}
  #FileType
  field=$(echo $human | awk -F ';' '{print $4}')
  echo -n "$field;" >> ${outputFile}
  #XResolution
  field=$(echo $human | awk -F ';' '{print $5}')
  echo -n "$field;" >> ${outputFile}
  #ImageSize
  field=$(echo $human | awk -F ';' '{print $6}')
  echo -n "$field;" >> ${outputFile}
  #Megapixels
  field=$(echo $numeric | awk -F ';' '{print $7}')
  echo -n "$field;" >> ${outputFile}
  #GPSLatitude
  field=$(echo $numeric | awk -F ';' '{print $8}')
  echo -n "$field;" >> ${outputFile}
  #GPSLongitude
  field=$(echo $numeric | awk -F ';' '{print $9}')
  echo -n "$field;" >> ${outputFile}
  #GPSPosition
  field=$(echo $numeric | awk -F ';' '{print $10}')
  echo -n "$field;" >> ${outputFile}
  #ImageWidth
  field=$(echo $numeric | awk -F ';' '{print $11}')
  echo -n "$field;" >> ${outputFile}
  #ImageHeight
  field=$(echo $numeric | awk -F ';' '{print $12}')
  echo -n "$field;" >> ${outputFile}
  #FileSize
  field=$(echo $numeric | awk -F ';' '{print $13}')
  echo -n "$field;" >> ${outputFile}
  #Five Blank fields
  echo -n ";;;;;" >> ${outputFile}
  #ImageDescription
  field=$(echo $human | awk -F ';' '{print $14}')
  # Last column no trailing command and finish with CR
  echo "$field" >> ${outputFile}
done

