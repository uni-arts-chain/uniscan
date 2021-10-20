#!/bin/bash
# rev4 - changes suggested by KownBash https://www.reddit.com/r/bash/comments/5cxfqw/i_wrote_a_simple_video_to_gif_bash_script_thought/da19gjz/

# Usage function, displays valid arguments
usage() { echo "Usage: $0 [-f <fps, defaults to 15>] [-w <width, defaults to 480] inputfile" 1>&2; exit 1; }

# Default variables
fps=15
width=480

# getopts to process the command line arguments
while getopts ":f:w:" opt; do
    case "${opt}" in
        f) fps=${OPTARG};;
        w) width=${OPTARG};;
        *) usage;;
    esac
done

# shift out the arguments already processed with getopts
shift "$((OPTIND - 1))"
if (( $# == 0 )); then
    printf >&2 'Missing input file\n'
    usage >&2
fi

# set input & output variable to the first option after the arguments
input="$1"
output="$2"

# Extract filename from output file
filename=$(basename "$output")

# Debug display to show what the script is using as inputs
echo "Input: $input"
echo "Output: $output"
echo "FPS: $fps"
echo "Width: $width"

# temporary file to store the first pass pallete
palette="/tmp/palette.png"

# options to pass to ffmpeg
filters="fps=$fps,scale=$width:-1:flags=lanczos"

# ffmpeg first pass
ffmpeg -v warning -i "$input" -vf "$filters,palettegen" -y $palette
# ffmpeg second pass
ffmpeg -v warning -i "$input" -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=3" -y "$output"

# display output file size
filesize=$(du -h "$output" | cut -f1)
echo "Output File Name: $filename"
echo "Output File Size: $filesize"
