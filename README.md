# u30p-boot-video

Magisk module that replaces the ZTE U30 Pro (MU5358, 240x240 screen) boot animation with a video.

- Source video: `video/boot.mp4`. It is scaled to 240x240 and converted to `bootanimation.zip` at 24 fps. It plays once in full, then holds the last frame until boot completes.
- Every push to `main` builds the module in GitHub Actions and publishes a release (`v1.0.<commit count>`). Magisk checks the latest release's `update.json` and offers the update.
- Bootloop guard: if a boot does not reach `sys.boot_completed`, the module disables itself on the next boot (log: `/data/adb/u30p-boot-video/log`).

To change the video, replace `video/boot.mp4` and push.

Web tool: https://kaandikec.com/u30p-boot-video/ — pick any video, adjust framing/trim/fps in the browser, and download a ready-to-flash Magisk zip. Nothing is uploaded; frames are extracted with `<video>` + canvas and zipped with fflate. A zip built there replaces the installed module and does not follow repo updates.

Local build: `scripts/build.sh` (requires ffmpeg and zip) → `out/u30p-boot-video.zip`.
