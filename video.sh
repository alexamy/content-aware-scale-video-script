#!/bin/bash

# check number of arguments
if [ "$#" -ne 4 ]; then
  exit
fi

# command line arguments
input=$1
result=$2
percent_w=$3
percent_h=$4

mkdir -p frames

ffmpeg -i $input -r 24 "frames/frame%04d.png"

find frames -name '*.png' \
  | sort \
  | xargs cat \
  | ffmpeg -f image2pipe -framerate 24 -i - $result
