#!/bin/bash

# check number of arguments
if [ "$#" -ne 5 ]; then
  echo "wrong number of arguments"
  exit
fi

# command line arguments
input=$1
result=$2
percent_w=$3
percent_h=$4
framerate=$5

# size of frame
vw=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=nw=1:nk=1 $input)
vh=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 $input)

# output frames
echo "splitting video to frames"
mkdir -p frames
ffmpeg -i $input -r $framerate "frames/frame%04d.png"

# list of frames
frames=$(find frames -name '*.png' | sort)
count=$(expr $(echo $frames | wc -w) - 1)

# increment to percentage
dw=$(echo "($percent_w - 100) / $count" | bc -l)
dh=$(echo "($percent_h - 100) / $count" | bc -l)

# resize frames
iw=100
ih=100
for frame in $frames
do
  echo "resizing $frame"
  convert $frame -liquid-rescale  "$iw x $ih %" $frame
  convert $frame -adaptive-resize "$vw x $vh" $frame
  iw=$(echo "$iw + $dw" | bc -l)
  ih=$(echo "$ih + $dh" | bc -l)
done

# make video
echo "making new video"
echo $frames | xargs cat \
  | ffmpeg -f image2pipe -framerate $framerate -i - $result

# delete frames folder
# rm -rf frames
