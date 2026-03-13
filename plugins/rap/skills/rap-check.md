---
description: Audit an R project against UK Government RAP compliance levels (Baseline, Silver, Gold)
---

# /rap-check — RAP Compliance Audit

## User Input

```text
$ARGUMENTS
```

## Instructions

You are auditing the current R project against the UK Government **Reproducible Analytical Pipelines (RAP)** maturity levels. There are three cumulative levels: **Baseline** (5 checks), **Silver** (9 checks, requires all Baseline), and **Gold** (4 checks, requires all Silver).

### 1. Detect R project

First, check whether the current directory is an R project:

- Look for `.R` files, `DESCRIPTION`, or `.Rproj` files.
- If none are found, display:

```
This directory does not appear to be an R project.

Run `/rap-init` to scaffold a new RAP-compliant R project, or navigate
to an existing R project directory.
```

Then stop — do not proceed with checks.

### 2. Determine project name

- If `DESCRIPTION` exists, extract `Package:` value.
- Otherwise, use the current directory name.

### 3. Run Baseline checks (B1–B5)

Run each check using the tools available to you (Read, Grep, Glob, Bash). Record the result as PASS, FAIL, or PARTIAL with a brief detail.

| ID | Requirement | How to Check |
|----|-------------|-------------|
| B1 | Code in open-source language | Use Glob to find `**/*.R` or `**/*.r` files. PASS if at least one found. |
| B2 | Version controlled with Git | Check if `.git/` directory exists. |
| B3 | README with reproduction steps | Check `README.md` exists. Grep for headings containing "run", "getting started", "reproduce", "steps", or "how to". PASS if file exists and contains at least one such heading. PARTIAL if file exists but lacks reproduction steps. |
| B4 | Code has been peer reviewed | Run `git log --oneline --merges` and check for merge commits. Alternatively check for `CONTRIBUTING.md`. PASS if either found. PARTIAL if repo is new with no history. |
| B5 | Code is published openly | Run `git remote -v` and check for a remote pointing to github.com, gitlab.com, or similar public host. |

### 4. Run Silver checks (S1–S9)

Only evaluate Silver if the user requests it or if all Baseline checks pass.

| ID | Requirement | How to Check |
|----|-------------|-------------|
| S1 | Minimal manual intervention | Look for `_targets.R`, a `run_all.R` script, or a `Makefile`. PARTIAL if only numbered scripts exist (e.g. `01_*.R, 02_*.R`). |
| S2 | Comprehensive documentation | Grep for roxygen2 comments (`#' @`) in R files. Check README length (> 50 lines). PASS if both present. |
| S3 | Standard directory structure | Check for `R/` directory containing `.R` files. |
| S4 | Reusable functions | Grep for `function(` in `R/` files. PASS if 3 or more function definitions found. |
| S5 | Coding standards | Check for `.lintr` config file. Alternatively check for `styler` in DESCRIPTION or scripts. |
| S6 | Testing framework | Check for `tests/testthat/` directory with at least one `test-*.R` or `test_*.R` file. |
| S7 | Dependency management | Check for `renv.lock` file. |
| S8 | Automatic logging | Grep across R files for `logger::`, `log_info`, `log_warn`, `log_error`, `message(`, or `futile.logger`. PASS if found in at least 2 files. |
| S9 | Tidy data format | Grep across R files for tidyverse patterns: `dplyr::`, `tidyr::`, `%>%`, `|>`, `tibble::`. PASS if found. |

### 5. Run Gold checks (G1–G4)

Only evaluate Gold if all Silver checks pass.

| ID | Requirement | How to Check |
|----|-------------|-------------|
| G1 | Fully packaged | Check that `DESCRIPTION` has a `Package:` field AND a `NAMESPACE` file exists. |
| G2 | CI/CD automation | Check for `.github/workflows/*.yml` files, or `.gitlab-ci.yml`. |
| G3 | Event/schedule triggers | Read CI config files and check for trigger definitions (`on: push`, `on: schedule`, `on: pull_request`). |
| G4 | Changelog & versioning | Check for `NEWS.md` or `CHANGELOG.md`. Check that `DESCRIPTION` has a `Version:` field. |

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
| S1 | Run `/rap-pipeline` to configure {targets} automation |
| S5 | Run `lintr::use_lintr(type = "tidyverse")` to create `.lintr` config |
| S6 | Run `/rap-test` to set up testthat framework |
| S7 | Run `renv::init()` to create `renv.lock` |
| S8 | Add `library(logger)` and use `log_info()` in your pipeline scripts |
| G1 | Run `usethis::use_namespace()` and ensure DESCRIPTION has a Package field |
| G2 | Add a GitHub Actions workflow: `usethis::use_github_action("check-standard")` |
| G4 | Run `usethis::use_news_md()` to create NEWS.md |

### 9. RAP context

End your response with:

> **RAP Maturity Levels** are defined by the [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/introduction_to_RAP/levels_of_RAP/) based on the [UK Government Analysis Function RAP strategy](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/). Achieving higher levels improves reproducibility, transparency, and efficiency of official statistics production.
>
> **Learn more:**
> - [Building RAPs with R](https://raps-with-r.dev/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
