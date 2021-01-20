#!/bin/bash

# search_dir=“/moudles/*”
# echo “Playgrounds you can choose from:”
# for item in “$search_dir”/*
# do
# arr[$count]+=“$entry”
# ls -la
# pwd
# done


find modules/ -name '*.tf'  | xargs tflint



