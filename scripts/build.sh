#!/usr/bin/env bash
# Build the Magisk module zip from video/boot.mp4.
# Usage: scripts/build.sh [versionCode]   (default: git commit count)
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
CODE=${1:-$(git -C "$ROOT" rev-list --count HEAD)}
VER=v1.0.$CODE
OUT=$ROOT/out; WORK=$OUT/work
W=240; H=240; FPS=24
rm -rf "$OUT"; mkdir -p "$WORK/anim/part0" "$WORK/anim/part1"

# Video -> PNG frames sized to the 240x240 panel.
ffmpeg -loglevel error -i "$ROOT/video/boot.mp4" \
  -vf "scale=$W:$H:force_original_aspect_ratio=decrease:flags=lanczos,pad=$W:$H:(ow-iw)/2:(oh-ih)/2:black,format=rgb24" \
  -r $FPS "$WORK/anim/part0/%05d.png"
cp "$(ls "$WORK"/anim/part0/*.png | tail -1)" "$WORK/anim/part1/00000.png"
# part0 plays once in full, part1 (last frame) holds until boot completes.
printf '%s %s %s\nc 1 0 part0\np 0 0 part1\n' $W $H $FPS > "$WORK/anim/desc.txt"

cp -R "$ROOT/module" "$WORK/module"
mkdir -p "$WORK/module/system/media"
# bootanimation.zip must be stored (no compression).
(cd "$WORK/anim" && zip -q -0 -r "$WORK/module/system/media/bootanimation.zip" desc.txt part0 part1)
sed -i.bak -e "s/^version=.*/version=$VER/" -e "s/^versionCode=.*/versionCode=$CODE/" "$WORK/module/module.prop" && rm "$WORK/module/module.prop.bak"
chmod 755 "$WORK"/module/*.sh
(cd "$WORK/module" && zip -q -r "$OUT/u30p-boot-video.zip" . -x '.*')
echo "$VER $CODE" > "$OUT/version"
echo "built $OUT/u30p-boot-video.zip ($VER, versionCode $CODE)"
