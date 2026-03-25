---
description: Scaffold a new RAP-compliant Python project following UK Government Analysis Function methodology
---

# /rap-py-init — Create a Python Reproducible Analytical Pipeline

## User Input

```text
$ARGUMENTS
```

## Instructions

You are scaffolding a new Python project that follows the UK Government **Reproducible Analytical Pipelines (RAP)** methodology. The generated project will immediately satisfy all **Baseline RAP** requirements and provide scaffolding toward Silver.

### 1. Parse project name

Extract the project name from `$ARGUMENTS`.

- If provided, sanitise it: lowercase, replace spaces with hyphens, remove special characters.
- If empty, use the current directory name as the project name.
- Store as `PROJECT_NAME`.
- Also derive `PROJECT_NAME_UNDERSCORE` by replacing hyphens with underscores (for Python package naming).

### 2. Check the target directory

Inspect the current working directory for existing files:

```bash
ls -A
```

- If the directory already contains `.py` files, `pyproject.toml`, or `setup.py`, **warn the user** that files exist and ask for confirmation before proceeding.
- If `.git/` already exists, note this — skip `git init` later.

### 3. Create directory structure

Create the RAP project directories:

```bash
mkdir -p src/PROJECT_NAME_UNDERSCORE data output tests reports
```

### 4. Write template files

For each template file listed below, read the template from the plugin's template directory, replace all occurrences of `{{PROJECT_NAME}}` with the actual project name and `{{PROJECT_NAME_UNDERSCORE}}` with the underscore variant, and write the result to the target path.

| Template Source | Target Path |
|----------------|-------------|
| `plugins/rap/templates/python-project/pyproject.toml.template` | `pyproject.toml` |
| `plugins/rap/templates/python-project/README.md.template` | `README.md` |
| `plugins/rap/templates/python-project/.gitignore.template` | `.gitignore` |
| `plugins/rap/templates/python-project/run_pipeline.py.template` | `run_pipeline.py` |
| `plugins/rap/templates/python-project/src/__init__.py.template` | `src/PROJECT_NAME_UNDERSCORE/__init__.py` |
| `plugins/rap/templates/python-project/src/read_data.py.template` | `src/PROJECT_NAME_UNDERSCORE/read_data.py` |
| `plugins/rap/templates/python-project/src/process_data.py.template` | `src/PROJECT_NAME_UNDERSCORE/process_data.py` |
| `plugins/rap/templates/python-project/src/analyse_data.py.template` | `src/PROJECT_NAME_UNDERSCORE/analyse_data.py` |
| `plugins/rap/templates/python-project/src/create_output.py.template` | `src/PROJECT_NAME_UNDERSCORE/create_output.py` |
| `plugins/rap/templates/python-project/data/README.md.template` | `data/README.md` |

### 5. Execute setup commands

**Git initialisation** (only if `.git/` does not already exist):

```bash
git init
```

**uv initialisation** (only if `uv.lock` does not already exist):

```bash
uv sync
```

> This creates a virtual environment and installs the project with its dependencies. The resulting `uv.lock` file pins exact versions for reproducibility.

If `uv` is not available on the system, skip and inform the user they can install dependencies manually.

### 6. Display summary

After all files are created, display a summary:

```markdown
## RAP Project Created: PROJECT_NAME

### Files created

- `pyproject.toml` — Project metadata, dependencies, and tool configuration
- `README.md` — Project documentation with reproduction steps
- `.gitignore` — Version control exclusions (protects sensitive data)
- `run_pipeline.py` — Pipeline entry point
- `src/PROJECT_NAME_UNDERSCORE/__init__.py` — Package initialisation
- `src/PROJECT_NAME_UNDERSCORE/read_data.py` — Data ingestion functions
- `src/PROJECT_NAME_UNDERSCORE/process_data.py` — Data cleaning and transformation
- `src/PROJECT_NAME_UNDERSCORE/analyse_data.py` — Statistical analysis
- `src/PROJECT_NAME_UNDERSCORE/create_output.py` — Output generation
- `data/README.md` — Data provenance documentation

### Directories created

- `src/PROJECT_NAME_UNDERSCORE/` — Analysis functions (Python package)
- `data/` — Input data (excluded from Git)
- `output/` — Generated outputs (excluded from Git)
- `tests/` — Unit tests
- `reports/` — Publication reports

### RAP Compliance

Your project now satisfies these **Baseline RAP** requirements:
- ✓ **B1**: Code in an open-source language (Python)
- ✓ **B2**: Version controlled with Git
- ✓ **B3**: README with reproduction steps

To complete Baseline, you also need:
- ○ **B4**: Peer review (open a PR for review)
- ○ **B5**: Publish openly (push to GitHub/GitLab)

### Next steps

1. Edit `data/README.md` to document your data sources
2. Update `src/PROJECT_NAME_UNDERSCORE/read_data.py` with your actual data ingestion code
3. Run `/rap-py-check` to audit your RAP compliance level
4. Run `/rap-py-test` to set up unit testing (Silver requirement)
5. Run `/rap-py-pipeline` to configure build automation
```

### 7. Edge Case Handling

Handle these situations gracefully:

- **Git not installed**: If `git init` fails with "command not found", display:
  ```
  Git is not installed. Install Git from https://git-scm.com/ then run `git init` manually.
  Your project files have been created successfully — Git can be added later.
  ```

- **Python not installed**: If `python` is not available, note it but still create all files:
  ```
  Python is not installed or not on PATH. Install Python from https://www.python.org/
  ```

- **uv not installed**: If `uv` is not available, skip `uv sync` and display:
  ```
  uv is not installed. Install uv from https://docs.astral.sh/uv/getting-started/installation/
  After installing uv, run: uv sync

  Alternatively, install dependencies with pip:
    python -m venv .venv
    source .venv/bin/activate  # or .venv\Scripts\activate on Windows
    pip install -e ".[dev]"
  ```

- **Permission errors**: If file creation fails, display the specific error and suggest checking directory permissions: `ls -la .`

- **setup.py / setup.cfg detected**: If `setup.py` or `setup.cfg` exists, warn:
  ```
  This project uses legacy Python packaging (setup.py/setup.cfg). Consider migrating
  to pyproject.toml which is the modern standard: https://packaging.python.org/en/latest/guides/writing-pyproject-toml/
  Skipping pyproject.toml creation to avoid conflicts.
  ```

- **Non-empty directory with conflicts**: If existing files would be overwritten, list them and ask for confirmation before proceeding. Never silently overwrite.

### 8. RAP Context

Include this brief context at the end of your response:

> **What is RAP?** Reproducible Analytical Pipelines apply software engineering practices to statistical production. Developed by the UK Government Analysis Function, RAP ensures official statistics are produced transparently, reproducibly, and efficiently.
>
> **Learn more:**
> - [UK Government Analysis Function RAP page](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
> - [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
> - [NHS RAP Python project template](https://nhsdigital.github.io/rap-community-of-practice/training_resources/python/project-structure-and-packaging/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
