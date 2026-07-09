# Contributing to superstore-sales-forecasting

This repository version-controls the Superstore Retail Sales Analysis &
Forecasting project end to end: the numbered document set (01, 08, 12, 15), the Power BI report (binary and
PBIP text form), Power Query scripts, and theme. Full setup detail lives in
`docs/08_GitHub_Repository_Setup_Guide.docx`; the full build walkthrough is `docs/15_Development_Guide.docx`.

## How each file type enters the repo

| File type | Tool | Workflow |
|---|---|---|
| Word docs, HTML, .pbix, screenshots | GitHub website | Upload files → descriptive commit message |
| PBIP text files (`pbip/`) | Power BI Desktop + GitHub Desktop | Save into the cloned folder → review diff → Commit → Push |
| Theme / M / measure catalog | Either | Small text files |

## Repository map

| Folder | Contents |
|---|---|
| `docs/` | Numbered document set (01, 08, 12, 15) |
| `pbix/` | Report binary — milestone copies only |
| `pbip/` | Power BI Project text files (TMDL) — the diffable source |
| `powerquery/` | `salesquota.pq` quota generation script |
| `dax/` | `measures.md` full measure catalog |
| `theme/` | `superstore_theme.json` |
| `assets/` | Page + model screenshots (README images) |

## Daily Power BI workflow

1. Fetch/Pull in GitHub Desktop before you start.
2. Work on the `.pbip` saved **inside the cloned repo folder** —
   files saved elsewhere are not tracked.
3. Read the TMDL diff, write a specific message, Commit to main, Push.

## Branches and pull requests

- Small solo changes may commit directly to `main`.
- Anything experimental or multi-file: branch `feature/<short-name>` →
  push → open a pull request → merge → pull `main` locally.

## Commit messages

Short, specific, present tense. State what and where:

- `Add quota attainment measures (03 Quota folder)`
- `Page 2: forecast settings + seasonality visual`
- `Doc PBI-RETAIL-001 v1.1: quota sample values refreshed`

## Data & secrets policy (public repository)

- **Never commit:** the Superstore CSV (README links to Kaggle/Tableau),
  any tokens, or PBIP local-settings/cache files.
- The `.gitignore` blocks the common cases, but it is a safety net, not a
  policy. If a secret is ever committed: rotate it immediately — removing
  the file does not remove it from history.
