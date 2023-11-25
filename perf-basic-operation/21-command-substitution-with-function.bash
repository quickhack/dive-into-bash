#!/usr/bin/env bash

v='/a/b/c.txt/'

base_name() {
  local x=${1%/}
  x=${x##*/}
  echo "$x"
}

# default to 100K times
count=${1:-100000}
for ((i = 0; i < count; ++i)); do
  x=$(base_name "$v")
done

# echo "$i $x"
