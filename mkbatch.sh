#!/bin/bash
# Achtung Windows nutzt Backslashes...

find . -name "*.ts" >> .tmp

while read i; do
	echo "$i"
	ASPECT=$(mediainfo "$i" | grep Display | cut -d" " -f25)
	WIDTH=$(mediainfo "$i" | grep Width | tr -dc '0-9')
	HEIGHT=$(mediainfo "$i" | grep Height | tr -dc '0-9')

	echo "$ASPECT, $WIDTH, $HEIGHT"

	echo "ffmpeg -i \"$i\" -c:v libx265 -s ${WIDTH}x${HEIGHT} -aspect $ASPECT -c:a ac3 -preset medium -crf 15 \"${i%.*}.mkv\"" | sed 's/\//\\/g' >> "$1"

	echo -e ""
done < .tmp

rm .tmp
