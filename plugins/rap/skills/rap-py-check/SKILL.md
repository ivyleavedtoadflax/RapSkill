---
description: Audit a Python project against UK Government RAP compliance levels (Baseline, Silver, Gold)
---

# /rap-py-check — RAP Compliance Audit

## User Input

```text
$ARGUMENTS
```

## Instructions

You are auditing the current Python project against the UK Government **Reproducible Analytical Pipelines (RAP)** maturity levels. There are three cumulative levels: **Baseline** (5 checks), **Silver** (9 checks, requires all Baseline), and **Gold** (4 checks, requires all Silver).

### 1. Detect Python project

First, check whether the current directory is a Python project:

- Look for `.py` files, `pyproject.toml`, `setup.py`, or `setup.cfg`.
- If none are found, display:

```
This directory does not appear to be a Python project.

Run `/rap-py-init` to scaffold a new RAP-compliant Python project, or navigate
to an existing Python project directory.
```

Then stop — do not proceed with checks.

### 2. Determine project name

- If `pyproject.toml` exists, extract `name` from `[project]` section.
- If `setup.py` or `setup.cfg` exists, extract the name from there.
- Otherwise, use the current directory name.

### 3. Run Baseline checks (B1–B5)

Run each check using the tools available to you (Read, Grep, Glob, Bash). Record the result as PASS, FAIL, or PARTIAL with a brief detail.

| ID | Requirement | How to Check |
|----|-------------|-------------|
| B1 | Code in open-source language | Use Glob to find `**/*.py` files. PASS if at least one found. |
| B2 | Version controlled with Git | Check if `.git/` directory exists. |
| B3 | README with reproduction steps | Check `README.md` exists. Grep for headings containing "run", "getting started", "reproduce", "steps", "install", or "how to". PASS if file exists and contains at least one such heading. PARTIAL if file exists but lacks reproduction steps. |
| B4 | Code has been peer reviewed | Run `git log --oneline --merges` and check for merge commits. Alternatively check for `CONTRIBUTING.md`. PASS if either found. PARTIAL if repo is new with no history. |
| B5 | Code is published openly | Run `git remote -v` and check for a remote pointing to github.com, gitlab.com, or similar public host. |

### 4. Run Silver checks (S1–S9)

Only evaluate Silver if the user requests it or if all Baseline checks pass.

| ID | Requirement | How to Check |
|----|-------------|-------------|
| S1 | Minimal manual intervention | Look for `Makefile`, `dvc.yaml`, a `run_pipeline.py` or `run_all.py` script, or a `__main__.py`. PARTIAL if only numbered scripts exist (e.g. `01_*.py, 02_*.py`). |
| S2 | Comprehensive documentation | Grep for docstrings (`"""` or `'''`) in Python files under `src/`. Check README length (> 50 lines). PASS if both present. |
| S3 | Standard directory structure | Check for `src/` directory containing `.py` files, or a package directory with `__init__.py`. |
| S4 | Reusable functions | Grep for `def ` in Python files under `src/` (or project package). PASS if 3 or more function definitions found. |
| S5 | Coding standards | Check for ruff configuration: `[tool.ruff]` in `pyproject.toml`, or a `ruff.toml`/`.ruff.toml` file. Alternatively check for `[tool.flake8]`, `[tool.pylint]`, `.flake8`, or `setup.cfg` with `[flake8]`. |
| S6 | Testing framework | Check for `tests/` directory with at least one `test_*.py` or `*_test.py` file. Alternatively check for `pytest` or `unittest` in configuration. |
| S7 | Dependency management | Check for `uv.lock`, `requirements.txt` with pinned versions (containing `==`), `poetry.lock`, or `Pipfile.lock`. PARTIAL if `pyproject.toml` has dependencies but no lockfile. |
| S8 | Automatic logging | Grep across Python files for `logging.getLogger`, `logging.info`, `logging.warning`, `logging.error`, `logger.info`, `logger.warning`, or `loguru`. PASS if found in at least 2 files. |
| S9 | Tidy data format | Grep across Python files for `import pandas`, `from pandas`, `import polars`, or `from polars`. PASS if found. |

### 5. Run Gold checks (G1–G4)

Only evaluate Gold if all Silver checks pass.

| ID | Requirement | How to Check |
|----|-------------|-------------|
| G1 | Fully packaged | Check that `pyproject.toml` has a `[build-system]` section AND an `__init__.py` exists in the package directory. |
| G2 | CI/CD automation | Check for `.github/workflows/*.yml` files, or `.gitlab-ci.yml`. |
| G3 | Event/schedule triggers | Read CI config files and check for trigger definitions (`on: push`, `on: schedule`, `on: pull_request`). |
| G4 | Changelog & versioning | Check for `CHANGELOG.md` or `NEWS.md`. Check that `pyproject.toml` has a `version` field. |

### 6. Calculate achieved level

The levels are cumulative:
- **Baseline**: All B1–B5 must PASS
- **Silver**: Baseline achieved AND all S1–S9 must PASS
- **Gold**: Silver achieved AND all G1–G4 must PASS

A PARTIAL counts as not achieved for level calculation but should be noted.

### 7. Format and display the report

Use this format:

```markdown
## RAP Compliance Report

**Project**: <project-name>
**Current Level**: BASELINE ✓/✗ | SILVER ✓/✗ | GOLD ✓/✗

### Baseline (<pass-count>/5)
- ✓/✗ B1: <requirement> (<detail>)
- ✓/✗ B2: <requirement> (<detail>)
- ✓/✗ B3: <requirement> (<detail>)
- ✓/✗ B4: <requirement> (<detail>)
- ✓/✗ B5: <requirement> (<detail>)

### Silver (<pass-count>/9)
- ✓/✗ S1: <requirement> (<detail>)
...

### Gold (<pass-count>/4)   [or "not evaluated — complete Silver first"]
- ✓/✗ G1: <requirement> (<detail>)
...

### Next Steps
<numbered list of actionable steps to reach the next level>
```

### 8. Provide actionable guidance

For each FAIL or PARTIAL check, include specific remediation:

| Check | Remediation |
|-------|-------------|
| B2 | Run `git init` to initialise version control |
| B3 | Add reproduction steps under a "How to Run" heading in README.md |
| B4 | Open a pull request and have a colleague review your code |
| B5 | Push to GitHub: `git remote add origin <url>` then `git push` |
| S1 | Run `/rap-py-pipeline` to configure build automation |
| S5 | Add ruff configuration to `pyproject.toml`: `[tool.ruff]` section with `select = ["E", "F", "W", "I"]` |
| S6 | Run `/rap-py-test` to set up pytest framework |
| S7 | Run `uv lock` to create `uv.lock` from `pyproject.toml`, or `pip freeze > requirements.txt` |
| S8 | Add `import logging` and use `logger = logging.getLogger(__name__)` in your pipeline modules |
| G1 | Add `[build-system]` to `pyproject.toml` and ensure your package has `__init__.py` |
| G2 | Add a GitHub Actions workflow: create `.github/workflows/ci.yml` |
| G4 | Create `CHANGELOG.md` and ensure `version` is set in `pyproject.toml` |

### 9. Edge Case Handling

Handle these situations gracefully:

- **No src/ directory**: If `src/` does not exist but `.py` files exist at the root, still run checks but note in S3 that the standard directory structure is not followed.

- **Git not initialised**: If `.git/` does not exist, B2 FAILS. Guidance: "Run `git init` or `/rap-py-init` to initialise version control."

- **requirements.txt without pinning**: If `requirements.txt` exists but packages are not pinned (no `==`), mark S7 as PARTIAL: "Dependencies listed but not pinned — use `uv lock` or `pip freeze` to pin exact versions."

- **setup.py instead of pyproject.toml**: Note this is legacy packaging and suggest migrating: "Consider migrating to `pyproject.toml` — see https://packaging.python.org/en/latest/guides/writing-pyproject-toml/"

- **Non-standard test directory**: If `tests/` exists but contains no `test_*.py` files, mark S6 as PARTIAL: "Test directory found but no test files detected."

- **Large repositories**: If `src/` contains more than 50 files, summarise rather than listing every check detail.

### 10. RAP context

End your response with:

> **RAP Maturity Levels** are defined by the [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/introduction_to_RAP/levels_of_RAP/) based on the [UK Government Analysis Function RAP strategy](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/). Achieving higher levels improves reproducibility, transparency, and efficiency of official statistics production.
>
> **Learn more:**
> - [NHS RAP Community of Practice — Python](https://nhsdigital.github.io/rap-community-of-practice/training_resources/python/basic-python-data-analysis-operations/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
