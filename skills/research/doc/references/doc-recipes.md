# Doc recipes — document extraction & conversion (no GitHub skills needed)

Tools: pdftotext/pdfinfo/pdftoppm/pdfunite (poppler), qpdf, tesseract, docling (uv tool), libreoffice. Run from the directory containing the file; output **next to the source**, never overwrite.

## §1 — Extracting content

```bash
# PDF with text layer
pdfinfo '<f>.pdf'                                   # page count, metadata
pdftotext -layout '<f>.pdf' '<f>.extract.txt'       # keep column layout
pdftotext -layout '<f>.pdf' - | wc -c               # < ~200 chars/page → treat as scan, use OCR

# Scanned PDF / image → OCR
pdftoppm -png -r 200 '<f>.pdf' '<f>-pg'             # one PNG per page
tesseract '<f>-pg-1.png' '<f>-pg-1' -l vie+eng      # <name>.txt next to the image
for p in '<f>'-pg-*.png; do tesseract "$p" "${p%.png}" -l vie+eng; done   # batch OCR

# Complex PDF/DOCX → markdown
timeout 180 docling convert '<f>.pdf' --to md --output .                       # produces <name>.md
docling convert '<f>.pdf' --to md --output . --page-range 0-4                  # long PDF: first 5 pages
docling convert '<f>.docx' --to md --output .                                  # DOCX, keeps tables
libreoffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to txt:Text '<f>.docx'   # fallback

# XLSX → CSV (first sheet → <f>.csv)
libreoffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to csv '<f>.xlsx'
libreoffice --headless --convert-to 'csv:Text - txt - csv (StarCalc):44,34,76' '<f>.xlsx'   # other sheets
soffice --headless --convert-to html '<f>.xlsx'    # >10k rows / need markdown tables → slice from HTML
```

Pick docling for dense tables, 2-column layouts, formatted DOCX. First model download ~30–90s; cache it for offline use. PDF >5 pages: `--page-range` or split first (§2). No `mutool`/`pandoc` on this machine — do not suggest them.

## §2 — PDF conversion (merge/split/rotate)

```bash
pdfunite '<a>.pdf' '<b>.pdf' '<f>_merged.pdf'                     # merge
qpdf --pages . 1-3 -- '<f>.pdf' '<f>_p1-3.pdf'                    # extract first 3 pages
qpdf --split-pages=1 '<f>.pdf' '<f>_pg%d.pdf'                     # split per page
qpdf --rotate=90:1-2 '<f>.pdf' '<f>_90deg.pdf'                    # rotate pages 1-2
qpdf --empty --pages '<b>.pdf' 2,1 '<a>.pdf' 1 -- '<f>_mix.pdf'   # pick arbitrary pages
qpdf --object-streams=generate '<f>.pdf' '<f>_small.pdf'          # compress
pdftoppm -png -r 150 '<f>.pdf' '<f>-pg'                           # pages → PNG
magick '<f>-pg-1.png' '<f>-pg-2.png' '<f>_img.pdf'                # images → PDF
```

## §3 — Output naming

| Operation | Output file |
|---|---|
| text extraction | `<name>.extract.md` or `.extract.txt` (note the engine at the end) |
| OCR | `<name>.extract.txt` + `*-pg-*.png` next to the source |
| xlsx | `<name>.csv` |
| conversion | `<name>_<suffix>.pdf` (`_merged`, `_p1-3`, `_90deg`...) |

## §4 — Report export (md/HTML → docx)

LibreOffice **cannot read Markdown** → always go through a UTF-8 HTML intermediate. `-env:UserInstallation=file:///tmp/lo-$$` isolates the profile to avoid hangs when LibreOffice is already open.

0. **Session skills first** (anthropics, fetched per session): `./scripts/fetch-session.sh --skill docx --skill pdf` → styled `.docx`/PDF per each skill's instructions; requires network on first fetch, models/CSS local afterwards.
1. **pandoc** (if installed): `pandoc '<f>.md' -o '<f>.docx' --standalone`.
2. **soffice**: write `<f>.report.html` (`<meta charset="utf-8">`, code blocks as `<pre style="font-family:monospace">`), then:

```bash
soffice --headless -env:UserInstallation=file:///tmp/lo-$$ \
  --convert-to docx:"MS Word 2007 XML" --outdir "$(dirname '<f>.html')" '<f>.html'
```

3. Missing all three → stop and report how to install (`sudo apt install libreoffice pandoc`); **never** guess the output.

**Mandatory verification after conversion** (page count + mojibake):

```bash
mkdir -p /tmp/verify-$$ && cp '<f>.docx' /tmp/verify-$$/ && cd /tmp/verify-$$
soffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to pdf '<f>.docx'
pdfinfo '<f>.pdf' | grep Pages          # meets the required page count?
pdftotext '<f>.pdf' - | head -40        # Vietnamese diacritics intact, code blocks not mangled?
```

Missing pages → extend content and reconvert; broken diacritics/code → fix the HTML and reconvert. For Vietnamese fonts, set a system font with full diacritics (Liberation Serif / DejaVu Sans) in the HTML.
