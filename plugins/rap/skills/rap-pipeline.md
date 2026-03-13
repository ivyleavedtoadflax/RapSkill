---
description: Configure {targets} build automation for a RAP R project pipeline
---

# /rap-pipeline — Build Automation with {targets}

## User Input

```text
$ARGUMENTS
```

## Instructions

You are configuring build automation for a RAP R project using the `{targets}` package. Build automation is a **Silver RAP requirement** (S1: minimal manual intervention) — it replaces manually sourcing scripts in order with a dependency-aware pipeline that only re-runs what has changed.

### 1. Detect R project

Check the current directory for an R project (`.R` files, `DESCRIPTION`, or `.Rproj`).

If not an R project, display:

```
This directory does not appear to be an R project.
Run `/rap-init` to scaffold a new RAP-compliant project first.
```

Then stop.

### 2. Check for existing _targets.R

If `_targets.R` already exists in the project root:

1. Read it and display the current pipeline structure
2. Scan `R/` for any functions not currently included as targets
3. Suggest additions or improvements:
   - New functions that could be added as targets
   - Missing dependency links between targets
   - Opportunities for branching (e.g. per-region analysis)
4. Ask the user whether to update the existing file or leave it unchanged
5. If the user agrees, make the suggested updates

Then skip to step 5 (Update DESCRIPTION).

### 3. Scan R/ for pipeline functions

Use Glob to find all `.R` files in `R/`. For each file:

1. Read the file and extract exported function names (lines matching `^[a-zA-Z_][a-zA-Z0-9_.]* <- function(`)
2. Identify function parameters to determine dependencies between stages
3. Build a dependency map:
   - Functions that take no data parameters → data ingestion (sources)
   - Functions that take raw data → processing stage
   - Functions that take processed data → analysis stage
   - Functions that produce files/output → output stage

### 4. Generate _targets.R

Read the template from `plugins/rap/templates/pipeline/_targets.R.template`.

Replace `{{PROJECT_NAME}}` with the project name.

If the project has custom functions beyond the standard four-stage pattern, customise the `_targets.R` to include them:

- Map each detected function to a `tar_target()` call
- Wire up dependencies based on the function parameter analysis
- Add appropriate comments explaining each stage

Write the result to `_targets.R` in the project root.

### 5. Update DESCRIPTION

If `DESCRIPTION` exists, check whether `targets` is listed in `Imports:` or `Suggests:`. If not, add it to `Suggests:`:

```
Suggests:
    targets,
    tarchetypes
```

### 6. Display summary

```markdown
## Pipeline Configured

**File**: `_targets.R`

### Pipeline stages

| Target | Function | Depends on |
|--------|----------|------------|
| raw_data | read_source_data() | — |
| clean_data | process_data() | raw_data |
| analysis_results | analyse_data() | clean_data |
| output | create_output() | analysis_results |

### Running the pipeline

```r
# Run the full pipeline (only re-runs changed stages)
targets::tar_make()

# Visualise the dependency graph
targets::tar_visnetwork()

# Read a cached result
targets::tar_read(analysis_results)

# Check which targets are outdated
targets::tar_outdated()
```

### How {targets} helps RAP

- **Reproducibility**: The pipeline definition is code, not a manual process
- **Efficiency**: Only re-runs stages whose inputs have changed
- **Transparency**: `tar_visnetwork()` shows the full dependency graph
- **Auditability**: Results are cached with metadata for inspection
```

### 7. RAP context

End your response with:

> **Build automation** is Silver RAP requirement S1 (minimal manual intervention). The `{targets}` package by Will Landau is the recommended pipeline tool for R, endorsed by the [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/training_resources/R/R-functions-and-packages/). It replaces manually running numbered scripts with a dependency-aware, cached pipeline.
>
> **Learn more:**
> - [targets manual](https://books.ropensci.org/targets/)
> - [UK Government Analysis Function RAP page](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
> - [Building RAPs with R](https://raps-with-r.dev/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
