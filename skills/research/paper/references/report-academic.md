# International-standard report

Use for research or professional reports that require transparent methods, verifiable evidence, and explicit scholarly requirements. There is no single universal “international standard”: follow the relevant field, journal, institution, or user specification. When applicable, select a study-type guideline from the [EQUATOR Network](https://www.equator-network.org/reporting-guidelines/) or the relevant domain authority. Do not claim compliance without checking its checklist.

## Workflow

1. Identify the question, audience, submission requirements, study type, and applicable guideline. For a literature synthesis, describe the source-search/selection method rather than implying empirical research was conducted.
2. Extract sources with local tools when practical. For PDFs, use the `doc` skill — `references/doc-recipes.md`; keep extracted text in a sidecar and retain page/location references.
3. Build a concise outline: what each section answers, which evidence supports it, and which limitations must be stated.
4. Write to the requested structure and citation style. IMRAD is common for original research, not a default for every genre.
5. Check citations, methods, results, limitations, and conclusions. For PDF/DOCX export, verify layout and content with available local tools.

## Suggested structure

Keep only relevant sections and adapt them to the applicable guideline:

1. **Title and abstract:** identify the topic, aim, approach, and main findings/conclusion; use a structured abstract when required.
2. **Introduction:** necessary context, problem/question, and objective.
3. **Methods:** sources/data, selection criteria, analysis, and limitations; provide enough detail for assessment or replication when appropriate.
4. **Results and analysis:** organize findings by question; do not repeat full tables in prose.
5. **Discussion and conclusion:** interpret within the evidence, uncertainty, limitations, and supported implications.
6. **References:** include only cited sources, use the required style, and verify bibliographic details.

Appendices, large datasets, detailed tables, code, and full extractions belong in separate support files unless submission rules require them in the report.

## Length and verification

- Meet the requested page/word count without using a fixed words-per-page estimate as a proxy for quality or padding.
- If sources cannot support the requested scope, state the limitation; do not expand with unsupported examples or claims.
- Before delivery, check that the guideline fits, citations are verifiable, methods and conclusions do not exceed the data, no sources/pages were invented, and the exported file opens and is readable.
- For PDFs, `pdfinfo` and `pdftotext` can verify page count and text; use page-limited extraction when checking source locations. Never claim a check that was not run.

## Beyond-source context

Add background beyond the supplied material only when the user permits it. Identify it as an external source, cite a specific reputable reference, and distinguish it from findings drawn directly from the source set.
