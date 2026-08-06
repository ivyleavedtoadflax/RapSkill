---
description: Generate accessible statistical outputs (spreadsheets, charts, reports) following UK Government standards for Python
---

# /rap-py-output — Accessible Statistical Outputs

## User Input

```text
$ARGUMENTS
```

## Instructions

You are helping an analyst generate accessible statistical outputs that comply with UK Government Analysis Function standards. This skill creates Python code files from templates for three output types.

### 1. Parse subcommand

Extract the subcommand from `$ARGUMENTS`. Valid subcommands are:

- `spreadsheet` — Accessible ODS/XLSX tables using gptables
- `charts` — GOV.UK-style matplotlib theme and colour palette
- `report` — Jupyter notebook (default), or a reproducible Quarto publication (`report quarto`) where no number is typed by hand

If `$ARGUMENTS` is empty or the subcommand is not recognised, display:

```
Usage: /rap-py-output <type>

Available output types:

  spreadsheet  — Generate accessible spreadsheet code using gptables
                 Creates: src/<project_name>/create_spreadsheet.py
                 Packages: gptables

  charts       — Generate GOV.UK chart theme for matplotlib
                 Creates: src/<project_name>/chart_theme.py
                 Packages: matplotlib

  report       — Generate a publication report
                 Default:  reports/main_report.ipynb   (single Jupyter notebook)
                           Packages: jupyter
                 Quarto:   /rap-py-output report quarto
                           Scaffolds a reproducible publication in report/ where
                           no number is typed by hand — figures interpolated from
                           analysis outputs, tables built by executed code,
                           citations carrying provenance, plus guard tests.
                           Packages: jupyter, ipykernel, pyyaml

Example: /rap-py-output spreadsheet
```

Then stop.

### 2. Detect Python project

Check the current directory for a Python project (`.py` files, `pyproject.toml`, or `setup.py`).

If not a Python project, display:

```
This directory does not appear to be a Python project.
Run `/rap-py-init` to scaffold a new RAP-compliant project first.
```

Then stop.

### 3. Determine project layout

- If `pyproject.toml` exists, extract the project name and derive the package directory.
- Look for `src/PROJECT_NAME_UNDERSCORE/` as the package directory.
- If no `src/` layout, fall back to the root directory or a package directory with `__init__.py`.
- Store the target package directory as `PKG_DIR`.

### 4. Generate output file

Based on the subcommand, read the corresponding template, replace `{{PROJECT_NAME}}` and `{{PROJECT_NAME_UNDERSCORE}}` with the actual values, and write to the target path.

#### `spreadsheet`

- **Template**: `plugins/rap/templates/python-output/spreadsheet.py.template`
- **Target**: `PKG_DIR/create_spreadsheet.py`
- **Packages to add**: `gptables`

After writing, display:

```markdown
## Accessible Spreadsheet Created

**File**: `PKG_DIR/create_spreadsheet.py`

This generates ODS/XLSX workbooks with:
- Cover sheet (publication metadata)
- Table of contents
- Notes sheet (methodology, data quality)
- Data tables with proper headers

### Next steps

1. Edit the cover sheet metadata in `create_accessible_spreadsheet()`
2. Add your data tables to the `sheets` dictionary
3. Call the function from `create_output.py`:
   ```python
   from <project_name>.create_spreadsheet import create_accessible_spreadsheet
   create_accessible_spreadsheet(results)
   ```

### Accessibility standard

Follows the Government Analysis Function guidance:
[Releasing statistics in spreadsheets](https://analysisfunction.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/)
```

#### `charts`

- **Template**: `plugins/rap/templates/python-output/chart_theme.py.template`
- **Target**: `PKG_DIR/chart_theme.py`
- **Packages to add**: `matplotlib`

After writing, display:

```markdown
## GOV.UK Chart Theme Created

**File**: `PKG_DIR/chart_theme.py`

Provides:
- `theme_govuk()` — Apply clean, accessible matplotlib theme globally
- `GOVUK_COLOURS` — Government colour palette (colour-blind safe)
- `govuk_colours()` — Returns colour palette as a dictionary
- `annotate_govuk()` — Statistical commentary annotations

### Usage

```python
from <project_name>.chart_theme import theme_govuk, annotate_govuk

theme_govuk()

fig, ax = plt.subplots()
ax.plot(years, values, label="England")
ax.set_title("My Chart")
ax.legend()
annotate_govuk(ax, "Peak in Q3 2023", x=2023.5, y=150)
fig.savefig("output/chart.png", bbox_inches="tight")
```

### Accessibility standard

Follows the Government Analysis Function guidance:
[Data visualisation: charts](https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-charts/)
```

#### `report`

Check if the remaining arguments contain `quarto`. If so, scaffold the **Quarto
reproducible publication** (below). Otherwise write the single Jupyter notebook.

##### Jupyter notebook (`/rap-py-output report`)

A single-file notebook, good for an internal or exploratory report.

- **Template**: `plugins/rap/templates/python-output/report.ipynb.template`
- **Target**: `reports/main_report.ipynb`
- Create the `reports/` directory if it does not exist.
- **Packages to add**: `jupyter`

After writing, display:

```markdown
## Publication Report Template Created

**File**: `reports/main_report.ipynb`

Structure follows Official Statistics conventions: executive summary, main
findings, methodology, quality measures (Code of Practice), revisions, glossary,
contact.

### Next steps

1. Update the metadata cells (title, author, organisation)
2. Add your charts and tables in the findings sections
3. Run the notebook:
   ```bash
   jupyter nbconvert --execute reports/main_report.ipynb --to html
   ```

### Want a reproducible publication instead?

For an official-statistics publication where **no figure is typed by hand** —
every number interpolated from your analysis outputs, every table built by
executed code, every citation carrying its source's provenance, and guard tests
that catch the silent failures — scaffold the Quarto project:

  /rap-py-output report quarto
```

##### Quarto reproducible publication (`/rap-py-output report quarto`)

This is the recommended path for an official statistics release. It scaffolds a
self-contained Quarto project in `report/` together with the Python modules and
guard tests that make the publication reproducible. The design goal, adapted
from a working RAP publication, is that **the document is the argument and no
number in it is typed by hand**:

- **Every figure in the prose is interpolated.** Numbers are `{{< var
  dotted.path >}}` shortcodes resolved against `report/_variables.yml`, which is
  *generated* from your analysis results (`output/results.json`) by
  `report_variables.py`. A figure typed into the document is checked once and
  moved by no data refresh — so it is treated as a bug.
- **Every table and figure appears in the document as executed code**, even
  where that code is a single call into `src/` (`report_parts.py`). The reader
  can see which figures each table is built from, rather than being shown a
  pre-rendered table from a file they are not looking at.
- **Two output formats, for two audiences.** `gfm` (`report.md`) is committed to
  git with `wrap: preserve`, so a data refresh is a readable line-by-line diff;
  self-contained `html` (`embed-resources`) is the shareable publication.
- **Citations carry provenance.** `references.bib` is generated with each
  source's retrieval time and checksum, rendered by a numeric CSL — not
  footnotes kept in step by hand.
- **The silent failures are guarded by tests.** Quarto prints `**?var:path**`
  for an unresolved variable and `**key?**` for an unknown citation and *exits
  zero* either way. `tests/test_report_variables.py` and
  `tests/test_citations.py` read the `.qmd` source before any render and fail on
  a bad path, key, or footnote.

Write each template, substituting `{{PROJECT_NAME}}` and
`{{PROJECT_NAME_UNDERSCORE}}` as elsewhere in this skill. `PKG_DIR` is the
package directory determined in step 3.

| Template Source | Target Path |
|-----------------|-------------|
| `python-output/report/_quarto.yml.template` | `report/_quarto.yml` |
| `python-output/report/report.qmd.template` | `report/report.qmd` |
| `python-output/report/_environment.template` | `report/_environment` |
| `python-output/report/numeric-provenance.csl` | `report/numeric-provenance.csl` (copy verbatim) |
| `python-output/report/references.bib.template` | `report/references.bib` |
| `python-output/report/gitignore.template` | `report/.gitignore` |
| `python-output/report/example_results.json.template` | `output/results.json` (**only if it does not already exist** — never overwrite real results) |
| `python-output/report_variables.py.template` | `PKG_DIR/report_variables.py` |
| `python-output/report_parts.py.template` | `PKG_DIR/report_parts.py` |
| `python-output/test_report_variables.py.template` | `tests/test_report_variables.py` |
| `python-output/test_citations.py.template` | `tests/test_citations.py` |

- Create `report/`, `output/`, and `tests/` if they do not exist.
- **Packages to add**: `jupyter`, `ipykernel` (Quarto's engine imports these to
  execute the document's blocks), `pyyaml` (used by `report_variables.py`).
  Quarto itself is **not** a Python package — it is a separate CLI, pinned at
  its call site, not carried in the environment.

After writing, generate the variable namespace and run the guards so the
scaffold is verified from the first render:

```bash
python -m {{PROJECT_NAME_UNDERSCORE}}.report_variables   # writes report/_variables.yml
python -m pytest tests/test_report_variables.py tests/test_citations.py -q
```

After writing, display for **Quarto**:

```markdown
## Reproducible Publication Scaffolded (Quarto)

**Project**: `report/`  ·  **Document**: `report/report.qmd`

A reproducible statistical publication where no number is typed by hand:

| Piece | Role |
|-------|------|
| `report/report.qmd` | The document — prose with `{{< var >}}` figures and executed table blocks |
| `report/_quarto.yml` | Dual output: `gfm` (committed, diff-friendly) + self-contained `html` |
| `PKG_DIR/report_variables.py` | Flattens `output/results.json` → `report/_variables.yml` |
| `PKG_DIR/report_parts.py` | Builds each table, called from the document |
| `report/references.bib` + `numeric-provenance.csl` | Citations with retrieval time and checksum |
| `tests/test_report_variables.py`, `tests/test_citations.py` | Catch Quarto's silent var/citation failures |

### Next steps

1. Install the Quarto CLI (a separate binary): https://quarto.org/docs/get-started/
2. Point your analysis step at `output/results.json` (the scaffold ships an
   example so the project renders immediately — replace it with your real
   results, keyed by the names your prose cites).
3. Regenerate the namespace, then render:
   ```bash
   python -m {{PROJECT_NAME_UNDERSCORE}}.report_variables
   quarto render report/
   ```
   `quarto render report/` — the directory, not the file. `quarto render
   report/report.qmd` treats the file as standalone and skips `_variables.yml`,
   so every figure fails to resolve.
4. Wire it into your pipeline (`/rap-py-pipeline`) as two stages:
   - **report-vars**: `python -m {{PROJECT_NAME_UNDERSCORE}}.report_variables`
     — dep `output/results.json`, out `report/_variables.yml`
   - **report-render**: `quarto render report/` — deps `report/report.qmd`,
     `report/_variables.yml`, `report/references.bib`
5. Replace the worked example in `report.qmd` with your content, and generate
   `references.bib` from your download manifest (see the file's header).

### Reproducibility notes

- `report/_environment` sets `QUARTO_PYTHON` to `../.venv/bin/python` so Quarto's
  Jupyter engine imports *your* package, not a stray interpreter. Adjust if your
  virtualenv lives elsewhere.
- Pin the exact Quarto version in your environment; the `required-version` floor
  in `_quarto.yml` is only a backstop for a hand render.
- Commit `report.md` and `report/_variables.yml`; the `html` and `figures/` are
  git-ignored (track them with DVC or regenerate from the pipeline).

### Standard

Follows the [Code of Practice for Statistics](https://code.statisticsauthority.gov.uk/the-code/).
```

### 5. Update pyproject.toml

If `pyproject.toml` exists, check whether the required packages are already listed under `dependencies` or `[project.optional-dependencies]`. If not, add them to the `dependencies` list. Read the file, add the missing packages, and write it back.

### 6. Edge Case Handling

Handle these situations gracefully:

- **Target file already exists**: If the output file already exists, warn and ask for confirmation before overwriting.

- **Missing pyproject.toml**: If no `pyproject.toml` exists, skip the dependency addition step and display:
  ```
  No pyproject.toml found. Install the required packages manually:
    pip install gptables
  ```

- **reports/ directory missing** (for `report` subcommand): Create it automatically with `mkdir -p reports/`.

- **No src/ or package directory**: If generating to the package directory but it doesn't exist, create it first with `__init__.py`.

- **gptables version compatibility**: Note that gptables requires Python >= 3.8 and suggest checking their Python version with `python --version`.

### 7. RAP context

End your response with:

> **Accessible outputs** are a key requirement of the UK Government Analysis Function. Statistical publications must be accessible to all users, including those using assistive technology. The gptables package and GOV.UK chart guidance help ensure compliance.
>
> **Learn more:**
> - [Government Analysis Function accessibility guidance](https://analysisfunction.civilservice.gov.uk/policy-store/making-analytical-publications-accessible/)
> - [gptables documentation](https://gptables.readthedocs.io/)
> - [UK Government Analysis Function RAP page](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
> - [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
