#!/bin/bash
# Achtung Windows nutzt Backslashes...

for i in $(find . -name "*.ts"); do
	echo "$i"
	#ASPECT=$(mediainfo "$i" | grep Display | cut -d" " -f25)
	#WIDTH=$(mediainfo "$i" | grep Width | tr -dc '0-9')
	#HEIGHT=$(mediainfo "$i" | grep Height | tr -dc '0-9')
	ASPECT="16:9"
	WIDTH=720
	HEIGHT=576

	echo "$ASPECT, $WIDTH, $HEIGHT"

	echo "ffmpeg -i \"$i\" -c:v libx265 -s ${WIDTH}x${HEIGHT} -aspect $ASPECT -c:a ac3 -preset medium -crf 15 \"${i%.*}.mkv\"" | sed 's/\//\\/g' >> "$1"

	echo -e ""
done
