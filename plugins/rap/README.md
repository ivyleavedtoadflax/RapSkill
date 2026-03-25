# RAP Plugin for Claude Code

A Claude Code plugin that helps analysts implement [Reproducible Analytical Pipelines (RAP)](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/) in R and Python, based on the UK Government Analysis Function methodology.

## Installation

First, bootstrap the plugin system (one-time setup):

```bash
git clone --depth 1 https://github.com/ivyleavedtoadflax/RapSkill /tmp/rapskill \
  && mkdir -p .claude/commands .claude/plugins \
  && cp /tmp/rapskill/.claude/commands/plugin.*.md .claude/commands/ \
  && cp /tmp/rapskill/.claude/plugins/*.json .claude/plugins/ \
  && rm -rf /tmp/rapskill
```

Then in Claude Code:

```
/plugin.marketplace-add https://github.com/ivyleavedtoadflax/RapSkill
/plugin.install rap
```

## Available Commands

### R

| Command | Description |
|---------|-------------|
| `/rap-init` | Scaffold a RAP-compliant R project with standard directory structure, configuration files, and starter templates |
| `/rap-check` | Audit your R project against the three UK government RAP maturity levels (Baseline/Silver/Gold) |
| `/rap-output` | Generate accessible statistical outputs: spreadsheets (a11ytables), GOV.UK-styled charts (govstyle), R Markdown reports |
| `/rap-test` | Set up testthat infrastructure and generate starter test files for existing R functions |
| `/rap-pipeline` | Configure {targets} build automation with a generated _targets.R reflecting your workflow |

### Python

| Command | Description |
|---------|-------------|
| `/rap-py-init` | Scaffold a RAP-compliant Python project with `src/` layout, `pyproject.toml`, and uv dependency management |
| `/rap-py-check` | Audit your Python project against the three UK government RAP maturity levels (Baseline/Silver/Gold) |
| `/rap-py-output` | Generate accessible statistical outputs: spreadsheets (gptables), GOV.UK matplotlib theme, Jupyter notebook or Quarto reports |
| `/rap-py-test` | Set up pytest infrastructure and generate starter test files for existing Python functions |
| `/rap-py-pipeline` | Configure build automation: Makefile (default) or DVC pipeline for complex data workflows |

## Python Tooling

The Python skills use modern, well-supported tools:

| Purpose | Tool | Why |
|---------|------|-----|
| Dependency management | [uv](https://docs.astral.sh/uv/) | Fast, lockfile-based, PEP 621 compliant |
| Testing | [pytest](https://docs.pytest.org/) | Universal Python testing standard |
| Linting & formatting | [ruff](https://docs.astral.sh/ruff/) | Fast all-in-one linter and formatter |
| Accessible spreadsheets | [gptables](https://gptables.readthedocs.io/) | GSS-maintained, UK gov standard |
| Charts | [matplotlib](https://matplotlib.org/) | With GOV.UK accessible theme |
| Reports | [Jupyter](https://jupyter.org/) / [Quarto](https://quarto.org/) | Notebook default, Quarto optional |
| Build automation | Make / [DVC](https://dvc.org/) | Simple default, DVC for complex pipelines |

## RAP Maturity Levels

The UK government defines three levels of RAP compliance:

### Baseline

- Code written in an open-source language (R or Python)
- Version controlled with Git
- Repository includes README with reproduction steps
- Code has been peer reviewed
- Code is published openly

### Silver (all Baseline requirements plus)

- Outputs produced with minimal manual intervention
- Comprehensive documentation including function docstrings
- Well-organized code following standard directory structure
- Reusable functions used where appropriate
- Adherence to coding standards
- Testing framework
- Dependency management
- Automatic logging
- Tidy data format for outputs

### Gold (all Silver requirements plus)

- Code is fully packaged
- Automated testing via CI/CD (GitHub Actions)
- Process runs on event-based triggers or schedule
- Changes documented with changelog and semantic versioning

## UK RAP Resources

- [Government Analysis Function — RAP](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
- [RAP Strategy](https://analysisfunction.civilservice.gov.uk/policy-store/reproducible-analytical-pipelines-strategy/)
- [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
- [Building Reproducible Analytical Pipelines with R](https://raps-with-r.dev/)
- [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
