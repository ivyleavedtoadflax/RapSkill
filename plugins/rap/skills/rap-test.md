---
description: Set up testthat testing framework and generate test skeletons for RAP R projects
---

# /rap-test — Testing and Data Validation

## User Input

```text
$ARGUMENTS
```

## Instructions

You are setting up testing infrastructure for a RAP R project. Testing is a **Silver RAP requirement** (S6) that ensures analytical functions produce correct, reproducible results.

### 1. Parse subcommand

Check `$ARGUMENTS` for a subcommand:

- *(empty)* — Set up testthat and generate skeleton test files for all R/ functions
- `data-validation` — Generate data validation test functions

If the subcommand is not recognised, display:

```
Usage: /rap-test [subcommand]

Subcommands:

  (no argument)     Set up testthat and generate test skeletons
  data-validation   Generate data validation tests

Examples:
  /rap-test
  /rap-test data-validation
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

### 3. Default subcommand — Set up testthat

#### 3a. Create testthat infrastructure

Check if `tests/testthat.R` already exists. If not:

1. Create directories: `tests/testthat/`
2. Read the template from `plugins/rap/templates/test/testthat.R.template`
3. Replace `{{PROJECT_NAME}}` with the project name (from DESCRIPTION Package field or directory name)
4. Write to `tests/testthat.R`

If `tests/testthat.R` already exists, skip this step and note it.

#### 3b. Scan for function files

Use Glob to find all `.R` files in `R/`. For each file:

1. Extract the filename without extension (e.g. `01_read_data` from `R/01_read_data.R`)
2. Check if `tests/testthat/test-{filename}.R` already exists
3. If it exists, **skip it** — never overwrite existing tests
4. If it does not exist, read the function file to find the first exported function name (look for lines matching `^[a-zA-Z_][a-zA-Z0-9_.]* <- function(`)
5. Read the skeleton template from `plugins/rap/templates/test/test-skeleton.R.template`
6. Replace `{{FILE_NAME}}` with the source filename (e.g. `01_read_data.R`)
7. Replace `{{FUNCTION_NAME}}` with the detected function name (or `my_function` if none found)
8. Write to `tests/testthat/test-{filename}.R`

#### 3c. Update DESCRIPTION

If `DESCRIPTION` exists, check if `testthat` is in the `Suggests:` field. If not, add it:

```
Suggests:
    testthat (>= 3.0.0)
```

Also ensure `Config/testthat/edition: 3` is present.

#### 3d. Display summary

```markdown
## Testing Framework Set Up

### Created files

- `tests/testthat.R` — Test runner [created/already existed]
- `tests/testthat/test-{filename}.R` — Skeleton tests for each function

### Skipped (already exist)

- [list any skipped test files]

### Running tests

```r
# Run all tests
devtools::test()

# Run tests in a specific file
testthat::test_file("tests/testthat/test-01_read_data.R")

# Run tests from the command line
Rscript -e "testthat::test_dir('tests/testthat')"
```

### RAP Compliance

Testing satisfies Silver RAP requirement **S6: Testing framework**.
Run `/rap-check` to see your updated compliance level.
```

### 4. Subcommand: `data-validation`

Generate a data validation test file at `tests/testthat/test-data-validation.R`.

If this file already exists, warn and ask for confirmation before overwriting.

The generated file should contain test functions that:

1. **Schema validation**: Check expected columns exist, column types are correct
2. **Value range checks**: Numeric values within expected bounds, dates within reporting period
3. **Categorical validation**: Factor/character values from expected sets
4. **Missing data patterns**: Acceptable NA rates, no unexpected complete missingness
5. **Uniqueness checks**: No unexpected duplicates on key columns
6. **Row count checks**: Data has expected number of rows (within tolerance)

Read the skeleton template from `plugins/rap/templates/test/test-skeleton.R.template` and use the data validation section as the basis, but uncomment and customise the examples based on any R files found in the project.

Display:

```markdown
## Data Validation Tests Created

**File**: `tests/testthat/test-data-validation.R`

Validates:
- Column presence and types
- Value ranges and categorical values
- Missing data patterns
- Duplicate detection
- Row count expectations

### Usage

Edit the test file to match your actual data schema, then run:

```r
testthat::test_file("tests/testthat/test-data-validation.R")
```

### Why validate data?

Data validation catches upstream changes before they silently corrupt
your statistics. When your data source adds a column, changes a format,
or introduces unexpected values, these tests fail immediately rather
than producing incorrect outputs.
```

### 5. RAP context

End your response with:

> **Testing** is a Silver RAP requirement. The [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/training_resources/python/unit-testing/) recommends testing both analytical functions and input data. Well-tested pipelines catch errors early, making it safe to update and re-run analyses with confidence.
