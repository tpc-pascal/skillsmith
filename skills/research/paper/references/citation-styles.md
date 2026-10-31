# Citation styles

Pick one style per report and keep it consistent through in-text citations and the reference list. Never invent metadata — every DOI, URL, page number, and year must come from a retrieved source.

## Styles

|Style|In-text|Reference entry|Use when|
|---|---|---|---|
|APA 7|(Author, Year)|Author, A. A. (Year). Title of work. Publisher or Journal. https://doi.org/xxxx|Social sciences, education, psychology|
|IEEE|[1], [2]|[1] A. Author, "Title," *Journal*, vol. x, no. x, pp. x-x, Year.|Engineering, computer science|
|Chicago author-date|(Author Year)|Author, First. Year. "Title." Journal x (x): x-x.|History, general humanities (author-date form)|
|Vancouver|[1]|1. Author AA. Title. Journal. Year;vol(issue):pages.|Biomedical journals|

## BibTeX via CrossRef

Resolve a DOI to BibTeX (network required):

```bash
curl -sL -H "Accept: application/x-bibtex" "https://doi.org/10.xxxx/xxxxx"
```

- When offline, transcribe the metadata already collected in the source file — do not guess fields.
- A DOI looks like `10.xxxx/xxxxx`; if the source does not show one, do not fabricate it. CrossRef search: `https://api.crossref.org/works?query.bibliographic=<title>`.

## Rules

- One style per report; the style named by the requester wins.
- In-text citations and the reference list must match 1:1; no orphan entries.
- Page numbers, volume/issue, and author names are copied from the source, never inferred.
- For non-English sources keep the original title; add a bracketed translation only when the report language requires it.
- Flag retracted or unverifiable sources instead of citing them as current evidence.
