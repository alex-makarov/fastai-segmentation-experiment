#!/bin/bash

# $1 - input video file
# $2 - folder with labeled frames

# STEP 1 - convert video
ffmpeg -i $1 -vf "select=not(mod(n\,25))" -vsync vfr frame_%06d.jpg

# STEP 2 - rename files sequentially
for i in frame_[0-9]*.jpg; do
    n="10#${i//[^0-9]/}"
    m=$(($n-1))
    printf -v output_filename "frame_%06d.jpg" $m
    mv $i $output_filename
    echo "$i -> $output_filename"
done

# STEP 3 - copy only matching files
mkdir images
find $2 -type f -name 'frame*' -printf '%f\n' | sed {'s/png/jpg/'} | xargs -I {} cp {} images
