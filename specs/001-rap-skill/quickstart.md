# Quickstart: RAP Skill for Claude Code

## For Users (Installing the RAP Plugin)

### 1. Register the Plugin Source

In Claude Code, run:
```
/plugin.marketplace-add https://github.com/ivyleavedtoadflax/RapSkill
```

### 2. Install the RAP Plugin

```
/plugin.install rap
```

This copies 5 skill files into your project's `.claude/commands/` directory.

### 3. Initialize a New RAP Project

Navigate to an empty directory, then:
```
/rap-init my-statistics-report
```

This scaffolds a complete R project with:
- Standard RAP directory structure (R/, data/, output/, tests/)
- DESCRIPTION, README.md, .gitignore
- renv initialization for dependency management
- Starter R scripts for the analytical pipeline
- testthat setup

### 4. Check Your Compliance Level

```
/rap-check
```

See which RAP level (Baseline/Silver/Gold) your project meets and get actionable guidance for the next level.

### 5. Add Features as Needed

```
/rap-output spreadsheet    # Accessible spreadsheet scaffolding
/rap-output charts         # GOV.UK chart theming
/rap-output report         # R Markdown report template
/rap-test                  # testthat setup + skeleton tests
/rap-test data-validation  # Data validation functions
/rap-pipeline              # {targets} build automation
```

---

## For Developers (Contributing)

### Repository Structure

```
RapSkill/
├── .claude/commands/           # Plugin system commands
│   ├── plugin.marketplace-add.md
│   ├── plugin.install.md
│   ├── plugin.uninstall.md
│   └── plugin.list.md
├── plugins/rap/                # RAP plugin (the main product)
│   ├── manifest.yml
│   ├── skills/                 # One .md per slash command
│   └── templates/              # R code templates
└── specs/                      # Feature specifications
```

### Adding a New RAP Command

1. Create `plugins/rap/skills/<command-name>.md` with YAML frontmatter
2. Add the command to `plugins/rap/manifest.yml`
3. If the command generates files, add templates to `plugins/rap/templates/`
4. Test by running `/plugin.install rap` in a test project

### Skill File Format

```markdown
---
description: Brief description of what the command does
---

## User Input

\```text
$ARGUMENTS
\```

## Outline

1. Step-by-step instructions for Claude to follow
2. Use Bash tool for setup commands (safe, non-destructive only)
3. Use Write/Edit tools for generating R code files
4. Use Read/Glob/Grep tools for project inspection
```
