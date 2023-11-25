#!/usr/bin/env bash

v='/a/b/c.txt/'

# default to 1000 times
count=${1:-1000}
for ((i = 0; i < count; ++i)); do
  x=$(
    y=${v%/}
    y=${v##*/}
    echo "$y"
  )
done

# echo "$i $x"
