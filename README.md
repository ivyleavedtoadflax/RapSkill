# RapSkill

A [Claude Code](https://claude.com/claude-code) plugin that helps R analysts implement **Reproducible Analytical Pipelines (RAP)** based on the [UK Government Analysis Function methodology](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/).

RAP applies software engineering best practices — version control, automated testing, dependency management, and build automation — to the production of official statistics, replacing manual spreadsheet processes with reproducible, auditable code.

## Quick Start

### 1. Install the plugin system

Copy the four plugin management commands into your project's `.claude/commands/` directory:

- `plugin.marketplace-add.md`
- `plugin.install.md`
- `plugin.uninstall.md`
- `plugin.list.md`

### 2. Register this repository as a plugin source

```
/plugin.marketplace-add https://github.com/ivyleavedtoadflax/RapSkill
```

### 3. Install the RAP plugin

```
/plugin.install rap
```

This copies the five RAP skill files into your `.claude/commands/` directory, making them available as slash commands.

### 4. Create a RAP project

```
/rap-init my-statistics-pipeline
```

## Available Commands

| Command | Description |
|---------|-------------|
| `/rap-init [name]` | Scaffold a RAP-compliant R project with standard directory structure, configuration files, and starter templates |
| `/rap-check` | Audit your R project against the three UK government RAP maturity levels (Baseline, Silver, Gold) |
| `/rap-output <type>` | Generate accessible statistical outputs: `spreadsheet` (a11ytables), `charts` (GOV.UK theme), `report` (R Markdown) |
| `/rap-test` | Set up testthat infrastructure and generate test skeletons for existing R functions |
| `/rap-pipeline` | Configure {targets} build automation with a dependency-aware `_targets.R` |

## RAP Maturity Levels

The UK government defines three cumulative levels of RAP compliance. `/rap-check` audits your project against all 18 checks.

### Baseline (5 checks)

1. Code written in an open-source language (R or Python)
2. Version controlled with Git
3. Repository includes README with reproduction steps
4. Code has been peer reviewed
5. Code is published openly

### Silver (9 additional checks)

1. Outputs produced with minimal manual intervention
2. Comprehensive documentation including function docstrings
3. Well-organized code following standard directory structure
4. Reusable functions used where appropriate
5. Adherence to coding standards (lintr/styler)
6. Testing framework (testthat)
7. Dependency management (renv)
8. Automatic logging
9. Tidy data format for outputs

### Gold (4 additional checks)

1. Code is fully packaged as an R package
2. Automated testing via CI/CD (GitHub Actions)
3. Process runs on event-based triggers or schedule
4. Changes documented with changelog and semantic versioning

## Project Structure

```
RapSkill/
├── .claude/
│   ├── commands/           # Plugin system commands
│   │   ├── plugin.marketplace-add.md
│   │   ├── plugin.install.md
│   │   ├── plugin.uninstall.md
│   │   └── plugin.list.md
│   └── plugins/            # Plugin registry
│       ├── sources.json
│       └── registry.json
├── plugins/rap/
│   ├── manifest.yml         # Plugin manifest
│   ├── skills/              # RAP skill files (installed by /plugin.install)
│   │   ├── rap-init.md
│   │   ├── rap-check.md
│   │   ├── rap-output.md
│   │   ├── rap-test.md
│   │   └── rap-pipeline.md
│   └── templates/           # R project templates
│       ├── r-project/       # Project scaffolding templates
│       ├── output/          # Output generation templates
│       ├── test/            # Testing templates
│       └── pipeline/        # Build automation templates
└── specs/                   # Feature specifications
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
