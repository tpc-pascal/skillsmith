---
name: media
description: Process video/audio/image/URL — summarize, subtitles, cut/concat, OCR, download. Use when given media files or URLs needing content or conversion.
license: MIT
metadata:
  audience: media processing
  origin: custom
---

# media — video / audio / image / URL

Thin skill, **no code of its own**: routes to local CLIs and per-session third-party skills — see [`references/media-fetch.md`](references/media-fetch.md).

## Routing table by input type

Identify with `ffprobe`/`file`; for URLs inspect the returned filename.
|Input + need|Tool|Notes|Third-party skill|
|---|---|---|---|
|Media file metadata|`ffprobe` (local)|no session skill needed|—|
|Video/URL content summary|skill `watch` (claude-video)|`--engine local`; YouTube transcript summaries → local `yt-dlp` subs or whisper|`watch`|
|Video/URL text extraction (SRT/VTT)|`whisper` (local)|`whisper <file> --model tiny --write-subs`; install the CLI/model first|—|
|Cut/concat/transcode, GIF, frames, loudness|`ffmpeg` (local)|`-ss`/`-t`, concat demuxer, GIF/fps/volume filters|—|
|Subtitles: extract, shift, convert, burn|`ffmpeg` (local)|`subtitles=` filter, `-c:s` mux; source `.srt` from whisper or skill `web`|—|
|Shot/cut detection|`ffmpeg` (local)|`select='gt(scene,0.4)'` writes the frames|—|
|Frame content analysis (on-screen text)|`ffmpeg` frames → `tesseract` or the agent|local OCR, no session skill|—|
|Images/screenshots: OCR/resize/convert|`tesseract` / ImageMagick (local)|no session skill needed|—|
|Music from URL/file (metadata, lyrics)|`yt-dlp` + `ffprobe` (local)|`--write-info-json` for metadata|—|
|Download media from URL|`yt-dlp` (local)|URL needs connectivity; locked/social pages go through skill `web` (`agent-reach`)|—|
|Missing ffprobe/whisper/tesseract/uv…|install the CLI yourself|`ffprobe -version`, `whisper --help` sanity checks|—|

## Rules

1. **Output next to source**: summary `<name>.digest.md`, subtitles `<name>.srt|.vtt`, clips `<name>.clip-<t1>-<t2>.mp4`. Never overwrite the source.
2. **Timestamps/clips from real frames** — verify with `ffprobe`, never estimate.
3. **Verify before delivering**: output files must open in `ffprobe` with correct duration/codec.
4. **Match the input language** — answer in the language the user used.

## references

- [`references/media-fetch.md`](references/media-fetch.md) — per-session fetch guide + offline limits.
- [`references/media-recipes.md`](references/media-recipes.md) — self-authored local commands for every row (transcribe, cut, subtitles, OCR, audio, music metadata, download).
