#!/usr/bin/env bash

INPUT="$1"
OUT_FOLDER="$2"
FOLDS="$3"

ADD_RANDOMNESS=0

if [ -z "$INPUT" ] || [ -z "$FOLDS" ] || [ -z "$OUT_FOLDER" ]; then
    echo "Usage: $0 input.txt out_folder/ num_folds"
    exit 1
fi

LINE_COUNT=$(cat $INPUT | wc -l)
ELEMENTS_PER_FOLD=$((${LINE_COUNT} / $FOLDS))

echo "LineCount: $LINE_COUNT"

if [ "$ADD_RANDOMNESS" == 1 ]; then
    TMP=$(mktemp)
    sort --random-sort $INPUT > $TMP
    INPUT="$TMP"
fi

for i in $(seq 0 $(($FOLDS - 1))); do
    start=$(($i * $ELEMENTS_PER_FOLD + 1))
    end=$(($start + $ELEMENTS_PER_FOLD - 1))
    if [ $i == $((FOLDS - 1)) ]; then
        end=$LINE_COUNT
    fi
    sed "${start},\$!d;${end}q" $INPUT > $OUT_FOLDER/$i.txt
done

if [ ! -z "$TMP" ]; then
    rm "$TMP"
fi
