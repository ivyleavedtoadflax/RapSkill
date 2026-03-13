# RAP Plugin for Claude Code

A Claude Code plugin that helps R analysts implement [Reproducible Analytical Pipelines (RAP)](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/) based on the UK Government Analysis Function methodology.

## Installation

```
/plugin.marketplace-add https://github.com/ivyleavedtoadflax/RapSkill
/plugin.install rap
```

## Available Commands

| Command | Description |
|---------|-------------|
| `/rap-init` | Scaffold a RAP-compliant R project with standard directory structure, configuration files, and starter templates |
| `/rap-check` | Audit your R project against the three UK government RAP maturity levels (Baseline/Silver/Gold) |
| `/rap-output` | Generate accessible statistical outputs: spreadsheets (a11ytables), GOV.UK-styled charts (govstyle), R Markdown reports |
| `/rap-test` | Set up testthat infrastructure and generate starter test files for existing R functions |
| `/rap-pipeline` | Configure {targets} build automation with a generated _targets.R reflecting your workflow |

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
- Adherence to coding standards (lintr/styler)
- Testing framework (testthat)
- Dependency management (renv)
- Automatic logging
- Tidy data format for outputs

### Gold (all Silver requirements plus)

- Code is fully packaged as an R package
- Automated testing via CI/CD (GitHub Actions)
- Process runs on event-based triggers or schedule
- Changes documented with changelog and semantic versioning

## UK RAP Resources

- [Government Analysis Function — RAP](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/)
- [RAP Strategy](https://analysisfunction.civilservice.gov.uk/policy-store/reproducible-analytical-pipelines-strategy/)
- [NHS RAP Community of Practice](https://nhsdigital.github.io/rap-community-of-practice/)
- [Building Reproducible Analytical Pipelines with R](https://raps-with-r.dev/)
- [RAP Companion](https://ukgovdatascience.github.io/rap_companion/)
