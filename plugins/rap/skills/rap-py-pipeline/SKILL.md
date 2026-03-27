---
description: Configure build automation for a RAP Python project (Makefile, DVC, or simple runner)
---

# /rap-py-pipeline — Build Automation

## User Input

```text
$ARGUMENTS
```

## Instructions

You are configuring build automation for a RAP Python project. Build automation is a **Silver RAP requirement** (S1: minimal manual intervention) — it replaces manually running scripts in order with a dependency-aware pipeline that only re-runs what has changed.

This skill offers three tiers of automation:

1. **`run_pipeline.py`** — Simple sequential runner (created by `/rap-py-init`)
2. **`Makefile`** — Dependency-aware build automation (default, recommended for most projects)
3. **DVC** — Full pipeline + data versioning (for complex projects with large datasets)

### 1. Parse subcommand

Check `$ARGUMENTS` for a subcommand:

- *(empty)* or `make` — Generate a Makefile (default)
- `dvc` — Generate a DVC pipeline (`dvc.yaml`)

If the subcommand is not recognised, display:

```
Usage: /rap-py-pipeline [type]

Pipeline types:

  (no argument)  Generate a Makefile (recommended for most projects)
  make           Same as above
  dvc            Generate a DVC pipeline (for complex projects with large data)

Choosing the right tier:
  - Small pipeline (< 5 stages, single data source): run_pipeline.py is sufficient
  - Medium pipeline (5+ stages, want incremental re-runs): Makefile ← default
  - Complex pipeline (large data, versioned datasets, branching): DVC

Examples:
  /rap-py-pipeline
  /rap-py-pipeline dvc
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

- Extract the project name and `PROJECT_NAME_UNDERSCORE` from `pyproject.toml` or directory name.
- Locate the package directory (e.g. `src/PROJECT_NAME_UNDERSCORE/`).

### 4. Subcommand: `make` (default)

#### 4a. Check for existing Makefile

If `Makefile` already exists in the project root:

1. Read it and display the current targets
2. Scan the package directory for any functions not currently represented as Make targets
3. Suggest additions or improvements:
   - New modules that could be added as stages
   - Missing dependencies between stages
   - Opportunities for parallel execution
4. Ask the user whether to update the existing file or leave it unchanged
5. If the user agrees, make the suggested updates

Then skip to step 6 (Update pyproject.toml).

#### 4b. Scan source modules

Use Glob to find all `.py` files in the package directory (excluding `__init__.py`). For each file:

1. Read the file and extract function names (lines matching `^def [a-zA-Z_]`)
2. Identify function parameters to determine dependencies between stages
3. Build a dependency map:
   - Functions that take a path/directory parameter → data ingestion (sources)
   - Functions that take a DataFrame parameter → processing/analysis stage
   - Functions that produce files/output → output stage

#### 4c. Generate Makefile

Read the template from `plugins/rap/templates/python-pipeline/Makefile.template`.

Replace `{{PROJECT_NAME}}`, `{{PROJECT_NAME_UNDERSCORE}}` with actual values.

If the project has custom modules beyond the standard four-stage pattern, customise the Makefile to include them:

- Map each detected module/function to a Make target
- Wire up dependencies based on the function parameter analysis
- Add appropriate comments explaining each stage

Write the result to `Makefile` in the project root.

#### 4d. Display summary

```markdown
## Makefile Pipeline Configured

**File**: `Makefile`

### Pipeline stages

| Target | Function | Depends on |
|--------|----------|------------|
| .raw_data.parquet | read_source_data() | data/ source files |
| .clean_data.parquet | process_data() | .raw_data.parquet |
| .analysis_meta.json | analyse_data() | .clean_data.parquet |
| summary.csv | create_output() | .analysis_meta.json |

### Running the pipeline

```bash
# Run the full pipeline (only re-runs changed stages)
make all

# Show what would run without executing
make -n all

# Run tests
make test

# Run linter
make lint

# Clean all outputs
make clean

# Show available targets
make help
```

### How Make helps RAP

- **Reproducibility**: The pipeline definition is code, not a manual process
- **Efficiency**: Only re-runs stages whose inputs have changed (file timestamps)
- **Transparency**: `make -n` shows exactly what will execute
- **Simplicity**: No extra Python dependencies — Make is available everywhere
```

### 5. Subcommand: `dvc`

#### 5a. Check for existing dvc.yaml

If `dvc.yaml` already exists:

1. Read it and display the current pipeline stages
2. Suggest improvements or additions
3. Ask the user whether to update or leave it unchanged

#### 5b. Check DVC prerequisites

Check if DVC is installed:

```bash
dvc version
```

If not installed, display guidance but still generate `dvc.yaml`:

```
DVC is not installed. Install it:
  uv add dvc
  # or: pip install dvc

Then initialise DVC in your project:
  dvc init
```

Also check if DVC is initialised (`.dvc/` directory exists). If not, note that `dvc init` needs to be run.

#### 5c. Generate dvc.yaml

Read the template from `plugins/rap/templates/python-pipeline/dvc.yaml.template`.

Replace `{{PROJECT_NAME}}`, `{{PROJECT_NAME_UNDERSCORE}}` with actual values.

Customise based on detected modules, similar to the Makefile approach.

Write to `dvc.yaml` in the project root.

#### 5d. Display summary

```markdown
## DVC Pipeline Configured

**File**: `dvc.yaml`

### Pipeline stages

| Stage | Command | Dependencies | Outputs |
|-------|---------|-------------|---------|
| read_data | read_source_data() | data/, read_data.py | .raw_data.parquet |
| process_data | process_data() | .raw_data.parquet, process_data.py | .clean_data.parquet |
| analyse_data | analyse_data() | .clean_data.parquet, analyse_data.py | .analysis_meta.json |
| create_output | create_output() | .analysis_meta.json, create_output.py | summary.csv |

### Running the pipeline

```bash
# Run the full pipeline (only re-runs changed stages)
dvc repro

# Visualise the dependency graph
dvc dag

# Check which stages are outdated
dvc status

# Compare parameters across runs
dvc params diff
```

### When to use DVC over Make

DVC adds value when your project has:
- **Large data files** that shouldn't be in Git (DVC tracks them separately)
- **Multiple data versions** you need to switch between
- **Remote storage** (S3, GCS, Azure) for data and model artefacts
- **Experiment tracking** with metrics and parameters

For simpler pipelines, the Makefile approach (`/rap-py-pipeline make`) is sufficient.
```

### 6. Update pyproject.toml

For the DVC subcommand only: if `pyproject.toml` exists, check whether `dvc` is listed in dependencies. If not, add it to `[project.optional-dependencies]` under a `pipeline` key:

```toml
[project.optional-dependencies]
pipeline = [
    "dvc",
]
```

The Makefile approach does not require any additional Python dependencies.

### 7. Edge Case Handling

Handle these situations gracefully:

- **No source directory**: If the package directory does not exist, display:
  ```
  No package directory found. Run `/rap-py-init` to create the standard project structure,
  or create your package directory and add pipeline functions before running /rap-py-pipeline.
  ```

- **No functions found**: If Python files exist but contain no function definitions (only scripts), warn:
  ```
  Your Python files appear to be scripts rather than functions. Build automation works best
  with functions. Consider refactoring your scripts into functions:
    def read_data(data_dir):
        ...
  Then run /rap-py-pipeline again.
  ```

- **Existing Makefile or dvc.yaml**: Never overwrite without confirmation. Analyse the current configuration and suggest improvements instead.

- **pyproject.toml missing**: Skip dependency updates and note packages should be installed manually.

- **Windows without Make**: If on Windows, note:
  ```
  Make may not be available natively on Windows. Options:
  - Use WSL (Windows Subsystem for Linux)
  - Install Make via chocolatey: choco install make
  - Use Git Bash (includes make)
  - Use the simple runner instead: python run_pipeline.py
  ```

- **Circular dependencies detected**: If function analysis suggests circular dependencies, warn and suggest restructuring.

- **run_pipeline.py already exists**: Note that the Makefile/DVC is an upgrade from the simple runner. Both can coexist — `run_pipeline.py` is the simple fallback, `make`/`dvc repro` is the dependency-aware alternative.

### 8. RAP context

End your response with:

> **Build automation** is Silver RAP requirement S1 (minimal manual intervention). For Python RAP projects, a Makefile provides dependency-aware execution without extra Python dependencies, while DVC adds data versioning for complex pipelines. Both approaches replace manually running numbered scripts with reproducible, auditable build processes.
>
> **Learn more:**
> - [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
> - [DVC documentation](https://dvc.org/doc)
> - [UK Government Analysis Function RAP page](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
