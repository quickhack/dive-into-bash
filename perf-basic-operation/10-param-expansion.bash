#!/usr/bin/env bash

v='/a/b/c.txt/'

# default to 100K times
count=${1:-100000}
for ((i = 0; i < count; ++i)); do
  x=${v%/}
  x=${x##*/}
done

# echo "$i $x"
