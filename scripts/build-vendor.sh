#!/usr/bin/env bash
# Bundle the browser libraries into site/vendor/:
#   tango.js  - Tango WebUSB ADB client (USB installer)
#   gifuct.js - gifuct-js GIF decoder (GIF input)
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
cd "$TMP"
npm init -y >/dev/null
npm i --silent --ignore-scripts esbuild@0.25.10 @yume-chan/adb@2.6.4 @yume-chan/adb-daemon-webusb@2.3.2 @yume-chan/adb-credential-web@2.1.0 gifuct-js@2.1.2
cat > tango.js <<'JS'
export { Adb, AdbDaemonTransport } from "@yume-chan/adb";
export { AdbDaemonWebUsbDevice, AdbDaemonWebUsbDeviceManager } from "@yume-chan/adb-daemon-webusb";
export { default as AdbWebCredentialStore } from "@yume-chan/adb-credential-web";
JS
cat > gifuct.js <<'JS'
export { parseGIF, decompressFrames } from "gifuct-js";
JS
for f in tango gifuct; do
  npx esbuild $f.js --bundle --format=esm --minify --target=es2022 --legal-comments=eof --outfile="$ROOT/site/vendor/$f.js"
done
