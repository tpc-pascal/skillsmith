# Media recipes — local CLI commands for every media row

Self-authored recipes for the `media` skill — no third-party skill scripts. Every command runs on local files; URL steps need connectivity. Prerequisites must be installed before use; nothing here downloads a model implicitly.

## Prerequisites

| Tool | Check | Install |
|---|---|---|
| ffmpeg / ffprobe | `ffmpeg -version` | `sudo apt install ffmpeg` |
| tesseract | `tesseract --version` | `sudo apt install tesseract-ocr` (Vietnamese: `tesseract-ocr-vie`) |
| yt-dlp | `yt-dlp --version` | `pip install -U yt-dlp` |
| whisper | `whisper --help` | `pip install -U openai-whisper` (model downloads on first run) |

## Transcribe (video/audio → SRT/VTT)

```bash
whisper input.mp4 --model tiny --output_format srt        # fast draft
whisper input.mp4 --model small --output_format vtt       # better accuracy
```

Verify timestamps: open the `.srt` and check the first/last cues against `ffprobe -show_entries format=duration -of csv=p=0 input.mp4`.

## Cut, concat, GIF, frames

```bash
ffmpeg -ss 00:00:10 -t 5 -i in.mp4 -c copy out.mp4       # cut at keyframe, no re-encode
ffmpeg -ss 00:00:10.5 -t 5 -i in.mp4 -c:v libx264 -c:a aac out.mp4   # frame-accurate (re-encode)
printf "file 'a.mp4'\nfile 'b.mp4'\n" > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy joined.mp4   # same codec/size only
ffmpeg -i in.mp4 -vf "fps=1,scale=480:-1" -t 10 out.gif   # 1 fps preview GIF
ffmpeg -i in.mp4 -vf fps=1 frames_%03d.png                # one frame per second
```

## Subtitles

```bash
ffmpeg -i in.mp4 -vf "subs=sub.srt:force_style='FontSize=24'" -c:a copy burn.mp4   # burn in
ffmpeg -i in.mp4 -map 0:s:0 sub.srt                                            # extract embedded
ffmpeg -i sub.srt -c:s webvtt sub.vtt                                          # SRT → VTT
ffmpeg -itsoffset 2.5 -i in.mp4 -i sub.srt -map 0 -map 1:a -c copy shift.mp4   # shift all A/V by +2.5s
```

Shift a text subtitle without re-encoding: edit the timestamps, or use `-ss` on input when only media offset is wrong. Verify burned output: frame at a cue time must show the text.

## Scene and shot detection

```bash
ffmpeg -i in.mp4 -vf "select='gt(scene,0.4)',showinfo" -f null - 2>&1 | grep showinfo | head   # scene-change timestamps
ffmpeg -i in.mp4 -vf "select='gt(scene,0.4)'" -vsync vfr shot_%02d.png                          # keyframes at cuts
```

Lower the threshold (0.2) for more cuts, raise it (0.6) for fewer.

## OCR frames and images

```bash
ffmpeg -i in.mp4 -vf fps=1/5 ocr_%03d.png          # sample frames every 5 s
tesseract ocr_001.png out -l eng+vie --psm 6       # single column/region text
convert photo.jpg -resize 200% big.png             # ImageMagick: upscale before OCR of tiny text
```

## Audio (trim, normalize, silence)

```bash
ffmpeg -ss 00:01:00 -t 30 -i in.mp4 -vn -c:a aac clip.m4a            # trim audio only
ffmpeg -i in.wav -af "loudnorm=I=-16:TP=-1.5:LRA=11" norm.wav        # normalize loudness (podcast target)
ffmpeg -i in.wav -af silencedetect=noise=-40dB:d=2 -f null - 2>&1 | grep silence_   # find silent spans
ffmpeg -i in.mp4 -af "volume=2dB" -c:a aac boost.mp4                 # gain change
```

## Music metadata and lyrics (URL or file)

```bash
yt-dlp -J --skip-download URL > track.json        # full metadata JSON (title, artist, duration)
yt-dlp --write-info-json --write-subs --skip-download URL   # metadata + lyrics subs when source provides
ffprobe -v quiet -show_entries format_tags=title,artist,album -of default=nw=1 track.flac   # local tags
ffprobe -v quiet -show_entries format=duration,bit_rate -of csv=p=0 track.flac              # duration/bitrate
```

Lyrics are only fetched when the source site supplies them — never transcribe audio to invent lyrics.

## Download from URL

```bash
yt-dlp -f "bv*+ba/b" URL                    # best video+audio
yt-dlp -x --audio-format mp3 URL             # audio only
yt-dlp --write-subs --write-auto-subs --sub-langs "en,vi" URL   # with subtitles
```

Locked/social pages: route through skill `web` (`agent-reach`) — never log in or bypass a lock here.

## Verify outputs

- Media: `ffprobe out.mp4` — duration/codec must match the intent; `srt`/`vtt` must open with ordered timestamps.
- Never overwrite a source; write `<name>.clip-<t1>-<t2>.mp4`, `<name>.srt`, `<name>.digest.md` next to it.
- Offline rule: all of the above work offline only when the CLI and (for whisper) the model are already installed/cached.
