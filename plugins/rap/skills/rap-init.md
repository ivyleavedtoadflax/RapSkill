---
description: Scaffold a new RAP-compliant R project following UK Government Analysis Function methodology
---

# /rap-init — Create a Reproducible Analytical Pipeline

## User Input

```text
$ARGUMENTS
```

## Instructions

You are scaffolding a new R project that follows the UK Government **Reproducible Analytical Pipelines (RAP)** methodology. The generated project will immediately satisfy all **Baseline RAP** requirements and provide scaffolding toward Silver.

### 1. Parse project name

Extract the project name from `$ARGUMENTS`.

- If provided, sanitise it: lowercase, replace spaces with hyphens, remove special characters.
- If empty, use the current directory name as the project name.
- Store as `PROJECT_NAME`.

### 2. Check the target directory

Inspect the current working directory for existing files:

```bash
ls -A
```

- If the directory already contains R files, `DESCRIPTION`, or `renv.lock`, **warn the user** that files exist and ask for confirmation before proceeding.
- If `.git/` already exists, note this — skip `git init` later.

### 3. Create directory structure

Create the RAP project directories:

```bash
mkdir -p R data output tests/testthat reports
```

### 4. Write template files

For each template file listed below, read the template from the plugin's template directory, replace all occurrences of `{{PROJECT_NAME}}` with the actual project name, and write the result to the target path.

| Template Source | Target Path |
|----------------|-------------|
| `plugins/rap/templates/r-project/DESCRIPTION.template` | `DESCRIPTION` |
| `plugins/rap/templates/r-project/README.md.template` | `README.md` |
| `plugins/rap/templates/r-project/.gitignore.template` | `.gitignore` |
| `plugins/rap/templates/r-project/R/01_read_data.R.template` | `R/01_read_data.R` |
| `plugins/rap/templates/r-project/R/02_process_data.R.template` | `R/02_process_data.R` |
| `plugins/rap/templates/r-project/R/03_analyse_data.R.template` | `R/03_analyse_data.R` |
| `plugins/rap/templates/r-project/R/04_create_output.R.template` | `R/04_create_output.R` |
| `plugins/rap/templates/r-project/data/README.md.template` | `data/README.md` |

Additionally, create the RStudio project file:

**File**: `PROJECT_NAME.Rproj`
```
Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: No

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes

BuildType: Package
PackageUseDevtools: Yes
```

### 5. Execute setup commands

Run the following commands to initialise the project environment:

**Git initialisation** (only if `.git/` does not already exist):

```bash
git init
```

**renv initialisation** (only if `renv.lock` does not already exist):

```bash
Rscript -e "renv::init(bare = TRUE)"
```

> Use `bare = TRUE` so renv creates the infrastructure without trying to discover and install packages from the skeleton scripts. The user will add packages incrementally.

If R is not available on the system, skip `renv::init()` and inform the user they should run it manually when R is available.

### 6. Display summary

After all files are created, display a summary:

```markdown
## RAP Project Created: PROJECT_NAME

### Files created

- `DESCRIPTION` — R package metadata
- `README.md` — Project documentation with reproduction steps
- `.gitignore` — Version control exclusions (protects sensitive data)
- `PROJECT_NAME.Rproj` — RStudio project file
- `R/01_read_data.R` — Data ingestion functions
- `R/02_process_data.R` — Data cleaning and transformation
- `R/03_analyse_data.R` — Statistical analysis
- `R/04_create_output.R` — Output generation
- `data/README.md` — Data provenance documentation

### Directories created

- `R/` — Analysis functions (numbered for pipeline order)
- `data/` — Input data (excluded from Git)
- `output/` — Generated outputs (excluded from Git)
- `tests/testthat/` — Unit tests
- `reports/` — R Markdown reports

### RAP Compliance

Your project now satisfies these **Baseline RAP** requirements:
- ✓ **B1**: Code in an open-source language (R)
- ✓ **B2**: Version controlled with Git
- ✓ **B3**: README with reproduction steps

To complete Baseline, you also need:
- ○ **B4**: Peer review (open a PR for review)
- ○ **B5**: Publish openly (push to GitHub/GitLab)

### Next steps

1. Edit `data/README.md` to document your data sources
2. Update `R/01_read_data.R` with your actual data ingestion code
3. Run `/rap-check` to audit your RAP compliance level
4. Run `/rap-test` to set up unit testing (Silver requirement)
5. Run `/rap-pipeline` to configure {targets} build automation
```

### 7. RAP Context

Include this brief context at the end of your response:

> **What is RAP?** Reproducible Analytical Pipelines apply software engineering practices to statistical production. Developed by the UK Government Analysis Function, RAP ensures official statistics are produced transparently, reproducibly, and efficiently.
>
> **Learn more:**
> - [UK Government Analysis Function RAP page](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
> - [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
> - [Building RAPs with R](https://raps-with-r.dev/)
> - [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
