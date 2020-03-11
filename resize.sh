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

# size of original image
wt=$(identify -format "%w" $input)
ht=$(identify -format "%h" $input)
percent_size="$percent_w x $percent_h%"
original_size="$wt x $wh"

# liquid rescale and resize to original
convert $input  -liquid-rescale  "$percent_size"  $result
convert $result -adaptive-resize "$original_size" $result
