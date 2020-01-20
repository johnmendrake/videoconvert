#!/bin/bash
# Achtung Windows nutzt Backslashes...

function usage {
	cat <<EOF
This script creates a batch file for windows to convert ts-files to mkv regarding the corresponsing resolution and aspect ratio of the original ts-file.
	video   :       h265
	audio   :       ac3.

It makes use of the tool:
	- mediainfo
so make sure you have it installed!

Mandatory option:
	$0 [output_command_file]

NOTE:
Script should be in the top level directory of the files that shall be concerted.
If you don't want to converte single files you can exclude them from the batch file at a later point.
EOF
}

function make_cmd {
	# get all ts-files
	find . -name "*.ts" >> .tmp

	while read i; do
		echo "$i"
		# get data
		ASPECT=$(mediainfo "$i" | grep Display | cut -d" " -f25)
		WIDTH=$(mediainfo "$i" | grep Width | tr -dc '0-9')
		HEIGHT=$(mediainfo "$i" | grep Height | tr -dc '0-9')

		# print data for debugging purpose
		echo "$ASPECT, $WIDTH, $HEIGHT"

		# generate ffmpeg command, translate it to MS file format and append it to the batch file
		echo "ffmpeg -i \"$i\" -c:v libx265 -s ${WIDTH}x${HEIGHT} -aspect $ASPECT -c:a ac3 -preset medium -crf 15 \"${i%.*}.mkv\"" | sed 's/\//\\/g' >> "$1"

		echo -e ""
	done < .tmp

	# clean up
	rm .tmp
}

# script has to be run with exactly one destination fiel as a parameter
if [ $# -gt 1 ]; then
	echo "Too many arguments!"
	echo ""
	usage
	exit
elif [ $# -lt 1 ]; then
	echo "Too few arguments!"
	echo ""
	usage
	exit
elif [ $# -eq 1 ]; then
	make_cmd $1
fi
