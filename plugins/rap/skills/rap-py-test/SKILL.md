---
description: Set up pytest testing framework and generate test skeletons for RAP Python projects
---

# /rap-py-test — Testing and Data Validation

## User Input

```text
$ARGUMENTS
```

## Instructions

You are setting up testing infrastructure for a RAP Python project. Testing is a **Silver RAP requirement** (S6) that ensures analytical functions produce correct, reproducible results.

### 1. Parse subcommand

Check `$ARGUMENTS` for a subcommand:

- *(empty)* — Set up pytest and generate skeleton test files for all source modules
- `data-validation` — Generate data validation test functions

If the subcommand is not recognised, display:

```
Usage: /rap-py-test [subcommand]

Subcommands:

  (no argument)     Set up pytest and generate test skeletons
  data-validation   Generate data validation tests

Examples:
  /rap-py-test
  /rap-py-test data-validation
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

- Extract the project name and package name (underscore variant) from `pyproject.toml` or directory name.
- Locate the package directory: `src/PROJECT_NAME_UNDERSCORE/` or a root-level package with `__init__.py`.
- Store as `PKG_DIR` and `PROJECT_NAME_UNDERSCORE`.

### 4. Default subcommand — Set up pytest

#### 4a. Create pytest infrastructure

Check if `tests/conftest.py` already exists. If not:

1. Create directory: `tests/`
2. Read the template from `plugins/rap/templates/python-test/conftest.py.template`
3. Replace `{{PROJECT_NAME}}` and `{{PROJECT_NAME_UNDERSCORE}}` with the actual values
4. Write to `tests/conftest.py`

If `tests/conftest.py` already exists, skip this step and note it.

#### 4b. Scan for source modules

Use Glob to find all `.py` files in the package directory (e.g. `src/PROJECT_NAME_UNDERSCORE/`), excluding `__init__.py`. For each file:

1. Extract the module name without extension (e.g. `read_data` from `read_data.py`)
2. Check if `tests/test_{module_name}.py` already exists
3. If it exists, **skip it** — never overwrite existing tests
4. If it does not exist, read the source file to find the first function name (look for lines matching `^def [a-zA-Z_][a-zA-Z0-9_]*\(`)
5. Read the skeleton template from `plugins/rap/templates/python-test/test_skeleton.py.template`
6. Replace `{{FILE_NAME}}` with the source filename (e.g. `read_data.py`)
7. Replace `{{MODULE_NAME}}` with the module name (e.g. `read_data`)
8. Replace `{{FUNCTION_NAME}}` with the detected function name (or `my_function` if none found)
9. Replace `{{PROJECT_NAME_UNDERSCORE}}` with the package name
10. Write to `tests/test_{module_name}.py`

#### 4c. Update pyproject.toml

If `pyproject.toml` exists, check whether `pytest` is in the dependencies or optional-dependencies. If not, add it to `[project.optional-dependencies]` under a `dev` key:

```toml
[project.optional-dependencies]
dev = [
    "pytest>=7.0",
]
```

Also ensure `[tool.pytest.ini_options]` exists with `testpaths = ["tests"]`.

#### 4d. Display summary

```markdown
## Testing Framework Set Up

### Created files

- `tests/conftest.py` — Shared fixtures [created/already existed]
- `tests/test_{module}.py` — Skeleton tests for each module

### Skipped (already exist)

- [list any skipped test files]

### Running tests

```bash
# Run all tests
pytest

# Run all tests with verbose output
pytest -v

# Run tests in a specific file
pytest tests/test_read_data.py

# Run a specific test
pytest tests/test_read_data.py::TestStructure::test_returns_dataframe

# Run tests with coverage
pytest --cov=PROJECT_NAME_UNDERSCORE
```

### RAP Compliance

Testing satisfies Silver RAP requirement **S6: Testing framework**.
Run `/rap-py-check` to see your updated compliance level.
```

### 5. Subcommand: `data-validation`

Generate a data validation test file at `tests/test_data_validation.py`.

If this file already exists, warn and ask for confirmation before overwriting.

The generated file should contain test functions that:

1. **Schema validation**: Check expected columns exist, column types are correct
2. **Value range checks**: Numeric values within expected bounds, dates within reporting period
3. **Categorical validation**: String values from expected sets
4. **Missing data patterns**: Acceptable NA rates, no unexpected complete missingness
5. **Uniqueness checks**: No unexpected duplicates on key columns
6. **Row count checks**: Data has expected number of rows (within tolerance)

Read the skeleton template from `plugins/rap/templates/python-test/test_skeleton.py.template` and use the `TestDataValidation` class as the basis, but uncomment and customise the examples based on any source files found in the project.

Display:

```markdown
## Data Validation Tests Created

**File**: `tests/test_data_validation.py`

Validates:
- Column presence and types
- Value ranges and categorical values
- Missing data patterns
- Duplicate detection
- Row count expectations

### Usage

Edit the test file to match your actual data schema, then run:

```bash
pytest tests/test_data_validation.py -v
```

### Why validate data?

Data validation catches upstream changes before they silently corrupt
your statistics. When your data source adds a column, changes a format,
or introduces unexpected values, these tests fail immediately rather
than producing incorrect outputs.
```

### 6. Edge Case Handling

Handle these situations gracefully:

- **No source directory or no functions found**: If the package directory is empty or contains no function definitions, create the pytest infrastructure but skip skeleton generation. Display:
  ```
  No Python source modules found. Test infrastructure created.
  Add functions to your package then run /rap-py-test again to generate skeletons.
  ```

- **pytest not installed**: If the user tries to run tests and pytest is not installed, guide them:
  ```
  uv add --dev pytest
  # or: pip install pytest
  ```

- **Non-standard test directory**: If `tests/` exists but uses a different framework (e.g. `unittest` with `test_runner.py`), warn before creating pytest infrastructure and ask for confirmation.

- **pyproject.toml missing**: Skip the configuration update and note that pytest should be installed manually.

- **Functions with no parameters**: For functions like `get_config()` that take no arguments, adjust the skeleton to omit data validation patterns and focus on return value checks.

- **Existing test files**: Never overwrite — always skip and list what was skipped.

### 7. RAP context

End your response with:

> **Testing** is a Silver RAP requirement. The [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/training_resources/python/unit-testing/) recommends testing both analytical functions and input data. Well-tested pipelines catch errors early, making it safe to update and re-run analyses with confidence.
>
> **Learn more:**
> - [NHS RAP — Python unit testing](https://nhsdigital.github.io/rap-community-of-practice/training_resources/python/unit-testing/)
> - [UK Government Analysis Function RAP page](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
