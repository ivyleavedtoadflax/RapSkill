---
description: Generate accessible statistical outputs (spreadsheets, charts, reports) following UK Government standards
---

# /rap-output — Accessible Statistical Outputs

## User Input

```text
$ARGUMENTS
```

## Instructions

You are helping an analyst generate accessible statistical outputs that comply with UK Government Analysis Function standards. This skill creates R code files from templates for three output types.

### 1. Parse subcommand

Extract the subcommand from `$ARGUMENTS`. Valid subcommands are:

- `spreadsheet` — Accessible ODS/XLSX tables using {a11ytables}
- `charts` — GOV.UK-style ggplot2 theme and colour palette
- `report` — R Markdown publication template

If `$ARGUMENTS` is empty or the subcommand is not recognised, display:

```
Usage: /rap-output <type>

Available output types:

  spreadsheet  — Generate accessible spreadsheet code using {a11ytables}
                 Creates: R/create_spreadsheet.R
                 Packages: a11ytables, openxlsx

  charts       — Generate GOV.UK chart theme for ggplot2
                 Creates: R/chart_theme.R
                 Packages: ggplot2

  report       — Generate R Markdown publication template
                 Creates: reports/main_report.Rmd
                 Packages: rmarkdown, knitr

Example: /rap-output spreadsheet
```

Then stop.

### 2. Detect R project

Check the current directory for an R project (`.R` files, `DESCRIPTION`, or `.Rproj`).

If not an R project, display:

```
This directory does not appear to be an R project.
Run `/rap-init` to scaffold a new RAP-compliant project first.
```

Then stop.

### 3. Generate output file

Based on the subcommand, read the corresponding template, replace `{{PROJECT_NAME}}` with the project name (from `DESCRIPTION` Package field or directory name), and write to the target path.

#### `spreadsheet`

- **Template**: `plugins/rap/templates/output/spreadsheet.R.template`
- **Target**: `R/create_spreadsheet.R`
- **Packages to add**: `a11ytables`, `openxlsx`

After writing, display:

```markdown
## Accessible Spreadsheet Created

**File**: `R/create_spreadsheet.R`

This generates ODS/XLSX workbooks with:
- Cover sheet (publication metadata)
- Table of contents
- Notes sheet (methodology, data quality)
- Data tables with proper headers

### Next steps

1. Edit the cover sheet metadata in `create_accessible_spreadsheet()`
2. Add your data tables to the `tables_list`
3. Call the function from `R/04_create_output.R`:
   ```r
   create_accessible_spreadsheet(results)
   ```

### Accessibility standard

Follows the Government Analysis Function guidance:
[Releasing statistics in spreadsheets](https://analysisfunction.civilservice.gov.uk/policy-store/releasing-statistics-in-spreadsheets/)
```

#### `charts`

- **Template**: `plugins/rap/templates/output/chart-theme.R.template`
- **Target**: `R/chart_theme.R`
- **Packages to add**: `ggplot2`

After writing, display:

```markdown
## GOV.UK Chart Theme Created

**File**: `R/chart_theme.R`

Provides:
- `theme_govuk()` — Clean, accessible ggplot2 theme
- `scale_colour_govuk()` — Government colour palette (colour-blind safe)
- `scale_fill_govuk()` — Fill scale variant
- `annotate_govuk()` — Statistical commentary annotations

### Usage

```r
source(here::here("R", "chart_theme.R"))

ggplot(data, aes(x = year, y = value, colour = category)) +
  geom_line(linewidth = 1) +
  theme_govuk() +
  scale_colour_govuk() +
  labs(title = "My Chart", caption = "Source: My Department")
```

### Accessibility standard

Follows the Government Analysis Function guidance:
[Data visualisation: charts](https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-charts/)
```

#### `report`

- **Template**: `plugins/rap/templates/output/report.Rmd.template`
- **Target**: `reports/main_report.Rmd`
- Create the `reports/` directory if it does not exist.
- **Packages to add**: `rmarkdown`, `knitr`

After writing, display:

```markdown
## Publication Report Template Created

**File**: `reports/main_report.Rmd`

Structure follows Official Statistics conventions:
- Executive summary
- Main findings with charts and tables
- Data and methodology
- Quality measures (Code of Practice)
- Revisions log
- Glossary and contact information

### Next steps

1. Update the YAML header (title, author, organisation)
2. Add your charts and tables in the findings sections
3. Render the report:
   ```r
   rmarkdown::render("reports/main_report.Rmd",
     params = list(results = results))
   ```

### Standard

Follows the [Code of Practice for Statistics](https://code.statisticsauthority.gov.uk/the-code/).
```

### 4. Update DESCRIPTION

If a `DESCRIPTION` file exists, check whether the required packages are already listed under `Imports:` or `Suggests:`. If not, add them to the `Suggests:` section. Read the file, add the missing packages, and write it back.

### 5. RAP context

End your response with:

> **Accessible outputs** are a key requirement of the UK Government Analysis Function. Statistical publications must be accessible to all users, including those using assistive technology. The {a11ytables} package and GOV.UK chart guidance help ensure compliance.
>
> **Learn more:**
> - [Government Analysis Function accessibility guidance](https://analysisfunction.civilservice.gov.uk/policy-store/making-analytical-publications-accessible/)
> - [UK Government Analysis Function RAP page](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
> - [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
> - [Building RAPs with R](https://raps-with-r.dev/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
