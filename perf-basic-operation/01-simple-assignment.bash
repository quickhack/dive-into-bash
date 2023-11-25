#!/usr/bin/env bash

# default to 100K times
count=${1:-100000}
for ((i = 0; i < count; ++i)); do
  x="TEST$i"
done

# echo $x
