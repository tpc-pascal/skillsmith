# Session-scoped third-party skills (fetch, never install permanently)

This repo **does not contain** third-party skills. Fetch into session temp:

1. `scripts/fetch-session.sh --list` → see names; `--skill <name>` or `--all` — the script sparse-clones each source repo at the pinned commit SHA, copies into session temp.
2. Use from the fetched skill directory's `scripts/` folder.
3. Offline/no network: operations on local files work when the required CLIs and models are available. Fetching session skills, downloading URLs, and downloading uncached models require network; `yt-dlp` cannot download a URL offline.

Commit SHA + license per skill: the `TABLE` in `scripts/fetch-session.sh`. Session skills for `media`: `watch` (content summaries) and `youtube-summarizer` (YouTube transcript + structured summary).
