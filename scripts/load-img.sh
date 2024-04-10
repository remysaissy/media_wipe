#!/bin/sh

SIM_ID=$1
PLATFORM=${2:-android}
FOLDER=${3:-gen-photos}

echo "Loading photos from $(pwd)/$FOLDER in $PLATFORM simulator $SIM_ID"

# $1: image name
load_image() {
    if [ "$PLATFORM" = "ios" ]
    then
      xcrun simctl addmedia $SIM_ID $file
    else
      adb push $file /sdcard/Pictures/
    fi
}

MAX_JOBS=8
for file in $FOLDER/*; do
    while [ $(jobs -r | wc -l) -ge $MAX_JOBS ]; do
        wait
    done
    load_image $file&
done

# Refresher
if [ "$PLATFORM" = "android" ]
then
  adb shell "am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file:///sdcard/Pictures/"
fi
