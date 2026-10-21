---
name: web
description: Read web pages, social media and search online sources. Use when looking up URLs, articles, social posts or doing topic search.
license: MIT
metadata:
  audience: web/social/search reading
  origin: custom
---

# web — web, social media and search reader

Thin self-written skill: **no code of its own** — takes a URL/topic, fetches text with existing CLIs (agent-reach, Jina, exa); needs connectivity, offline only uses supplied local content.

## Routing table by need

|Need|Tool|Third-party skill|
|---|---|---|
|Read a web page/article (incl. paywalled)|`curl -s https://r.jina.ai/URL` (agent-reach web channel)|`agent-reach`|
|Read social media (Twitter/Reddit/XHS/FB/IG/Bilibili)|agent-reach upstream CLI: `twitter` / `opencli` / `bili` / `rdt`|`agent-reach`|
|YouTube/Bilibili → text/auto-captions|`yt-dlp --write-auto-sub --skip-download` / `bili`; paywalled → skill `media` (`watch`)|—|
|Web search by topic|mcp `exa.web_search_exa query="…" numResults=5`; Exa free has a rate limit|—|
|Broken/slow internet|`agent-reach doctor --json` — check which backend is active|`agent-reach`|

## Rules

1. **Match the input language** — answer in the language the user used.
2. **Name every output**: fetched file → cache/`<name>.extract.md|.txt`; never overwrite sources; summaries → `<name>.digest.md`.
3. **Never invent input** — only process real content; no fake URLs or quotes.
4. **Summaries from web/social/paid URLs** → `curl -s https://r.jina.ai/URL` first; if media → skill `media`.
5. **Locked content** (social, paywalls) → agent-reach/Jina reads it; no login, no bypass — tell the user if unreadable.
6. **Offline**: URLs, search, social APIs need connectivity; offline, read only user-supplied local content — this repo never creates a web cache.
7. **Always report the file written** (name + path) — never silently.
8. **Writing a report from web results** → hand off to `paper` after confirming requirements with `orchestrator`.
9. **Foreign-language sources** → translate only needed passages, mark `(translated from <language>)`; rules in [`references/translation.md`](references/translation.md).

## Third-party skills (fetched per session)

`agent-reach`: `./scripts/fetch-session.sh --skill agent-reach` → temp, never installed (backends for the routing table above).

Research workflow: `--skill deep-research` (Anthropic official harness from asgeirtj/system_prompts_leaks, CC0 — fan-out parallel WebSearch, dedup, adversarial multi-answer verification with a 2/3 vote), `--skill last30days` (mvanhorn, MIT — signal discovery across platforms over the last 30 days for research breadth), plus agentic-awesome-skills `--skill efficient-web-research` (token-efficient URL/repo/search protocol — fetch targeted passages, not full pages), `--skill wiki-researcher` (evidence-grounded trace for "how does X work" over repos/systems).

HTML design gate: `--skill taste-skill` (Leonxlnx/taste-skill, MIT) — run its checklist before delivering HTML/CSS/React one-pagers or public-facing pages. For system UI (dashboards, apps): `--skill impeccable` (pbakaus/impeccable, Apache-2.0) — design language for consistent components.

## references

- [`references/translation.md`](references/translation.md) — translating quotes and claims from foreign-language sources, with attribution and hedging preserved.

## Common combined flows

```text
URL web/social [network required] ▸ jina/agent-reach ▸ text ▸ paper (if a report is needed)
Topic search [network required] ▸ exa ▸ URL list ▸ jina ▸ text ▸ paper (if a report is needed)
URL media [network required] ▸ skill media ▸ digest + frame ▸ paper (if a report is needed)
```
