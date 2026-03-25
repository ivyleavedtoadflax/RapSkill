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
- `report` — Jupyter notebook publication template (default) or Quarto template

If `$ARGUMENTS` is empty or the subcommand is not recognised, display:

```
Usage: /rap-py-output <type>

Available output types:

  spreadsheet  — Generate accessible spreadsheet code using gptables
                 Creates: src/PROJECT_NAME/create_spreadsheet.py
                 Packages: gptables

  charts       — Generate GOV.UK chart theme for matplotlib
                 Creates: src/PROJECT_NAME/chart_theme.py
                 Packages: matplotlib

  report       — Generate publication report template
                 Creates: reports/main_report.ipynb (default)
                 Packages: jupyter, matplotlib
                 Option: /rap-py-output report quarto  (creates .qmd instead)

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
   from PROJECT_NAME.create_spreadsheet import create_accessible_spreadsheet
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
from PROJECT_NAME.chart_theme import theme_govuk, annotate_govuk

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

Check if the remaining arguments contain `quarto`. If so, use the Quarto template; otherwise use the Jupyter notebook template.

**Jupyter notebook (default):**

- **Template**: `plugins/rap/templates/python-output/report.ipynb.template`
- **Target**: `reports/main_report.ipynb`
- Create the `reports/` directory if it does not exist.
- **Packages to add**: `jupyter`

**Quarto (optional):**

- **Template**: `plugins/rap/templates/python-output/report.qmd.template`
- **Target**: `reports/main_report.qmd`
- Create the `reports/` directory if it does not exist.
- **Packages to add**: None (Quarto CLI is installed separately)

After writing, display for **Jupyter notebook**:

```markdown
## Publication Report Template Created

**File**: `reports/main_report.ipynb`

Structure follows Official Statistics conventions:
- Executive summary
- Main findings with charts and tables
- Data and methodology
- Quality measures (Code of Practice)
- Revisions log
- Glossary and contact information

### Next steps

1. Update the metadata cells (title, author, organisation)
2. Add your charts and tables in the findings sections
3. Run the notebook:
   ```bash
   jupyter nbconvert --execute reports/main_report.ipynb --to html
   ```

### Standard

Follows the [Code of Practice for Statistics](https://code.statisticsauthority.gov.uk/the-code/).

### Want parameterised rendering?

For publication-quality reports with parameterised rendering, consider Quarto:
  /rap-py-output report quarto

Quarto requires a separate CLI install: https://quarto.org/docs/get-started/
```

After writing, display for **Quarto**:

```markdown
## Publication Report Template Created (Quarto)

**File**: `reports/main_report.qmd`

Structure follows Official Statistics conventions:
- Executive summary
- Main findings with charts and tables
- Data and methodology
- Quality measures (Code of Practice)
- Revisions log
- Glossary and contact information

### Next steps

1. Install Quarto CLI: https://quarto.org/docs/get-started/
2. Update the YAML header (title, author, organisation)
3. Add your charts and tables in the findings sections
4. Render the report:
   ```bash
   quarto render reports/main_report.qmd
   ```

### Note

Quarto is a separate CLI tool (not a Python package). Install it from https://quarto.org/docs/get-started/
If you prefer a pure-Python approach, use `/rap-py-output report` for a Jupyter notebook instead.
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
