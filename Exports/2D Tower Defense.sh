#!/bin/sh
echo -ne '\033c\033]0;2d Tower Defense\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/2D Tower Defense.x86_64" "$@"
