#!/bin/sh

COUNT=${1:-20}
FOLDER=${2:-gen-photos}

echo "Generating $COUNT photos in folder $(pwd)/$FOLDER"
echo "Creating $FOLDER if doesn't exist yet."
mkdir -p $FOLDER

# $1: image ID
generate_image() {
   file_name="$(uuidgen | tr "[:upper:]" "[:lower:]")_$1.jpg"
#  file_name="$1.jpg"
  output=$FOLDER/$file_name
  creation_date=$(perl -MPOSIX -le 'use Time::Local; $time = int(rand(6 * 31536000)) + Time::Local::timelocal(0, 0, 0, 1, 0, 2023); print strftime("%Y:%m:%d %H:%M:%S", localtime($time))')
  text=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | head -c 30)
  shapes=("rectangle" "polygon" "circle")
  shape=${shapes[$((RANDOM % ${#shapes[@]}))]}
  size="4032x3024"
  bgcolor="#$(hexdump -n 3 -e '/1 "%02X"' /dev/urandom)"
  bgcolor2="#$(hexdump -n 3 -e '/1 "%02X"' /dev/urandom)"
  fgcolor="#$(hexdump -n 3 -e '/1 "%02X"' /dev/urandom)"
  width=$((RANDOM % 2016))
  height=$((RANDOM % 1512))
  x1=$((RANDOM % width))
  y1=$((RANDOM % height))
  x2=$((x1 + width))
  y2=$((y1 + height))
  x3=$((x2 + width))
  y3=$((y2 + height))
  case $shape in
  "polygon")
    draw="$shape $x1,$y1 $x2,$y2 $x3,$y3"
    ;;
  "circle"|"rectangle")
    draw="$shape $x1,$y1 $x2,$y2"
    ;;
  esac
  rotation=$((RANDOM % 2 == 0 ? 0 : 90))
  background_type=$((RANDOM % 2))
  case $background_type in
  0) # Fond uni
    convert -size $size xc:"$bgcolor" -fill "$fgcolor" -gravity center -font Arial -pointsize 62 -rotate $rotation -annotate 0 "$text" -draw "$draw" $output && exiftool -AllDates="$creation_date" $output
    ;;
  1) # Dégradé vertical
    convert -size $size gradient:"$bgcolor-$bgcolor2" -fill "$fgcolor" -font Arial -pointsize 62 -gravity center -rotate $rotation -annotate 0 "$text" -draw "$draw" $output && exiftool -AllDates="$creation_date" $output
    ;;
  esac
#   convert -size $size xc:"$bgcolor" -fill "$fgcolor" -gravity center -annotate 0 "$text" -draw "$shape $x1,$y1 $x2,$y2" $output && exiftool -AllDates="$creation_date" $output
}

MAX_JOBS=8
for i in $(seq 0 $COUNT); do
    while [ $(jobs -r | wc -l) -ge $MAX_JOBS ]; do
        wait
    done
    generate_image $i
done
# In case of, remove all temporary files.
rm $FOLDER/*_original
