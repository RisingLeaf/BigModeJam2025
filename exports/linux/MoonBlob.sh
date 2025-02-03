#!/bin/sh
echo -ne '\033c\033]0;BigMode-Jam\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/MoonBlob.x86_64" "$@"
