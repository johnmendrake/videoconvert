#!/bin/bash
# Script for converting ts-files to mkv (h265 + ac3)
# Needs ffmpeg + mediainfo to be installed!!!

function usage {
	cat <<EOF
This script can convert ts-files recorded with a "Kathrein UFS-222" and
propably many more into an mkv-file using the codecs:
	video	:	h265
	audio	:	ac3.

It makes use of the tools:
	- ffmpeg
	- mediainfo
so make sure you have them installed!

Available options:
	-a [/path/to/location]
		convert all a ts-files in the given location
		if no location is given, the default is your current one

	-f [/path/to/file]
		convert only the given file
EOF
}

# Method to do the actual work
function convert {
	echo "convert is checking file: $1"
	check_file "$1"
	if [ $? -eq 0 ]; then
		# Get all the needed values
		ASPECT=$(mediainfo "$1" | grep Display | cut -d" " -f25)
		WIDTH=$(mediainfo "$1" | grep Width | tr -dc '0-9')
		HEIGHT=$(mediainfo "$1" | grep Height | tr -dc '0-9')

		# Execute ffmpeg with the extracted parameters
		#	ffmpeg -i "$1" -c:v libx265 -s ${WIDTH}x${HEIGHT} -aspect $ASPECT -c:a ac3 -preset ultrafast -crf 18 "${1%.*}.mkv"
		echo "$1"
		echo $ASPECT
		echo $WIDTH
		echo $HEIGHT
	fi
}

# Secures that no files are overritten with brute force
function check_file {
	if [ -f "${1%.*}.mkv" ]; then
		echo ""\"${1%.*}.mkv\"" already exists!"
		read -p "Do you want to override it?[y/N]" yn
		case $yn in
			[y] )
				echo overwriting file
				return 0;;

			* )
				echo skipping file
				return 1;;
		esac
	else return 0
	fi 
}

if [ $# -gt 2 ]; then
	echo "Too many arguments!"
	echo ""
	usage
	exit
else
	case $1 in
		'-a')
			if [ $# -eq 2 ]; then
				cd "$2"
			fi
			for i in *.ts; do
				convert "$i"
			done
			exit;;

		'-f')
			convert "$2"
			exit;;

		* )
			usage
			exit;;
	esac
fi


#	WIDTH=`mediainfo "$i" | grep Width | cut -d" " -f38`
#       HEIGHT=`mediainfo "$i" | grep Height | cut -d" " -f37`
#	WIDTH=`mediainfo "$i" | grep Width | cut -d: -f2 | cut -d" " -f2`
#	HEIGHT=`mediainfo "$i" | grep Height | cut -d: -f2 | cut -d" " -f2`

