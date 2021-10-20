#!/bin/bash
animtoconvert=$1
nframe=$2
fps=$3

# Split in frames
convert $animtoconvert +adjoin temp_%02d.gif

# select the frames for the new animation
j=0
for i in $(ls temp_*gif); do 
    if [ $(( $j%${nframe} )) -eq 0 ]; then 
        cp $i sel_`printf %02d $j`.gif; 
    fi; 
    j=$(echo "$j+1" | bc); 
done

# Create the new animation & clean up everything
convert -delay $fps $( ls sel_*) new_animation.gif
rm temp_* sel_*
