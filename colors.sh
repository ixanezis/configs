#!/usr/bin/env bash
# Help script to print colors
for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
done