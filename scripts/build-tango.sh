#!/usr/bin/env bash
# Bundle Tango (WebUSB ADB client) into site/vendor/tango.js.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
cd "$TMP"
npm init -y >/dev/null
npm i --silent --ignore-scripts esbuild@0.25.10 @yume-chan/adb@2.6.4 @yume-chan/adb-daemon-webusb@2.3.2 @yume-chan/adb-credential-web@2.1.0
cat > entry.js <<'JS'
export { Adb, AdbDaemonTransport } from "@yume-chan/adb";
export { AdbDaemonWebUsbDevice, AdbDaemonWebUsbDeviceManager } from "@yume-chan/adb-daemon-webusb";
export { default as AdbWebCredentialStore } from "@yume-chan/adb-credential-web";
JS
npx esbuild entry.js --bundle --format=esm --minify --target=es2022 --legal-comments=eof --outfile="$ROOT/site/vendor/tango.js"
