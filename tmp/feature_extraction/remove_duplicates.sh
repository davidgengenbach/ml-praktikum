#!/usr/bin/env bash

IN=$1
IN_IMAGES=$2


if [ -z "$IN" ] || \
   [ -z "$IN_IMAGES" ]; then
    echo "Usage: $0 features.ids.txt features.txt"
    exit 1
fi

for id in $(sort $IN | uniq -c | sort -r | grep "2 " | cut -d " " -f 8); do
    cat $IN_IMAGES | grep "$id"
done