# RapSkill

A [Claude Code](https://claude.com/claude-code) plugin that helps analysts implement **Reproducible Analytical Pipelines (RAP)** in **R** and **Python**, based on the [UK Government Analysis Function methodology](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/).

RAP applies software engineering best practices — version control, automated testing, dependency management, and build automation — to the production of official statistics, replacing manual spreadsheet processes with reproducible, auditable code.

## Quick Start

### 1. Bootstrap the plugin system

Run this one-liner from your project directory. It downloads the four plugin management commands directly from GitHub — no cloning required, and it won't overwrite an existing plugin registry if you already have one set up.

```bash
REPO="https://raw.githubusercontent.com/ivyleavedtoadflax/RapSkill/main" && \
mkdir -p .claude/commands .claude/plugins && \
for cmd in plugin.marketplace-add plugin.install plugin.uninstall plugin.list; do \
  curl -fsSL "$REPO/.claude/commands/${cmd}.md" -o ".claude/commands/${cmd}.md"; \
done && \
[ -f .claude/plugins/sources.json ] || echo '[]' > .claude/plugins/sources.json && \
[ -f .claude/plugins/registry.json ] || echo '[]' > .claude/plugins/registry.json && \
echo "Plugin system ready."
```

This gives you four plugin management commands: `/plugin.marketplace-add`, `/plugin.install`, `/plugin.uninstall`, `/plugin.list`.

> **Requires**: `curl` (pre-installed on macOS and most Linux distributions; on Windows use Git Bash or WSL).

### 2. Register this repository as a plugin source

In Claude Code, run:

```
/plugin.marketplace-add https://github.com/ivyleavedtoadflax/RapSkill
```

This clones the repository temporarily, reads the plugin manifest, and registers it as an available source.

### 3. Install the RAP plugin

```
/plugin.install rap
```

This copies the 10 RAP skill files into your `.claude/commands/` directory, making them available as slash commands.

### 4. Create a RAP project

```
/rap-init my-statistics-pipeline       # R project
/rap-py-init my-statistics-pipeline    # Python project
```

## Available Commands

### R Commands

| Command | Description |
|---------|-------------|
| `/rap-init [name]` | Scaffold a RAP-compliant R project with standard directory structure, configuration files, and starter templates |
| `/rap-check` | Audit your R project against the three UK government RAP maturity levels (Baseline, Silver, Gold) |
| `/rap-output <type>` | Generate accessible statistical outputs: `spreadsheet` (a11ytables), `charts` (GOV.UK theme), `report` (R Markdown) |
| `/rap-test` | Set up testthat infrastructure and generate test skeletons for existing R functions |
| `/rap-pipeline` | Configure {targets} build automation with a dependency-aware `_targets.R` |

### Python Commands

| Command | Description |
|---------|-------------|
| `/rap-py-init [name]` | Scaffold a RAP-compliant Python project with `src/` layout, `pyproject.toml`, and uv dependency management |
| `/rap-py-check` | Audit your Python project against the three UK government RAP maturity levels (Baseline, Silver, Gold) |
| `/rap-py-output <type>` | Generate accessible statistical outputs: `spreadsheet` (gptables), `charts` (matplotlib GOV.UK theme), `report` (Jupyter notebook or Quarto) |
| `/rap-py-test` | Set up pytest infrastructure and generate test skeletons for existing Python functions |
| `/rap-py-pipeline [type]` | Configure build automation: `make` (default, Makefile) or `dvc` (for complex data pipelines) |

## RAP Maturity Levels

The UK government defines three cumulative levels of RAP compliance. `/rap-check` and `/rap-py-check` audit your project against all 18 checks.

### Baseline (5 checks)

1. Code written in an open-source language (R or Python)
2. Version controlled with Git
3. Repository includes README with reproduction steps
4. Code has been peer reviewed
5. Code is published openly

### Silver (9 additional checks)

| Requirement | R Tooling | Python Tooling |
|-------------|-----------|----------------|
| Minimal manual intervention | {targets} | Makefile / DVC |
| Comprehensive documentation | roxygen2 | Docstrings (numpy-style) |
| Standard directory structure | `R/` package layout | `src/` package layout |
| Reusable functions | R functions | Python functions |
| Coding standards | lintr / styler | ruff |
| Testing framework | testthat | pytest |
| Dependency management | renv | uv |
| Automatic logging | {logger} | logging (stdlib) |
| Tidy data format | tidyverse | pandas |

### Gold (4 additional checks)

| Requirement | R Tooling | Python Tooling |
|-------------|-----------|----------------|
| Fully packaged | R package (NAMESPACE) | Python package (pyproject.toml + build-system) |
| CI/CD automation | GitHub Actions | GitHub Actions |
| Event/schedule triggers | CI triggers | CI triggers |
| Changelog & versioning | NEWS.md | CHANGELOG.md |

## Project Structure

```
RapSkill/
├── .claude/
│   ├── commands/               # Plugin system commands
│   │   ├── plugin.marketplace-add.md
│   │   ├── plugin.install.md
│   │   ├── plugin.uninstall.md
│   │   └── plugin.list.md
│   └── plugins/                # Plugin registry
│       ├── sources.json
│       └── registry.json
├── plugins/rap/
│   ├── manifest.yml            # Plugin manifest
│   ├── skills/                 # RAP skill files (installed by /plugin.install)
│   │   ├── rap-init/           # R project scaffolding
│   │   ├── rap-check/          # R compliance audit
│   │   ├── rap-output/         # R accessible outputs
│   │   ├── rap-test/           # R testing setup
│   │   ├── rap-pipeline/       # R build automation
│   │   ├── rap-py-init/        # Python project scaffolding
│   │   ├── rap-py-check/       # Python compliance audit
│   │   ├── rap-py-output/      # Python accessible outputs
│   │   ├── rap-py-test/        # Python testing setup
│   │   └── rap-py-pipeline/    # Python build automation
│   └── templates/
│       ├── r-project/          # R project scaffolding templates
│       ├── output/             # R output generation templates
│       ├── test/               # R testing templates
│       ├── pipeline/           # R build automation templates
│       ├── python-project/     # Python project scaffolding templates
│       ├── python-output/      # Python output generation templates
│       ├── python-test/        # Python testing templates
│       └── python-pipeline/    # Python build automation templates
└── specs/                      # Feature specifications
```

## UK RAP Resources

- [Government Analysis Function — RAP](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
- [RAP Strategy](https://analysisfunction.civilservice.gov.uk/policy-store/reproducible-analytical-pipelines-strategy/)
- [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
- [Building Reproducible Analytical Pipelines with R](https://raps-with-r.dev/)
- [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
- [Code of Practice for Statistics](https://code.statisticsauthority.gov.uk/the-code/)

## Contributing

Contributions are welcome. To add or improve RAP skills:

1. Fork this repository
2. Create a feature branch from `main`
3. Make your changes
4. Open a pull request for review

Skill files are Markdown with YAML frontmatter — see `plugins/rap/skills/` for examples.

## Licence

MIT
