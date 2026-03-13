---
description: List installed plugins and registered plugin sources. Shows which plugins are available and which commands they provide.
---

## Outline

Display information about installed plugins and registered sources.

### 1. Read installed plugins

Read `.claude/plugins/registry.json`. If the file does not exist or is empty (`{}`), note that no plugins are installed.

### 2. Read registered sources

Read `.claude/plugins/sources.json`. If the file does not exist or is empty (`[]`), note that no sources are registered.

### 3. Display installed plugins

If plugins are installed, display them in a formatted table:

```
## Installed Plugins

| Plugin | Version | Commands |
|--------|---------|----------|
| <name> | <version> | /cmd1, /cmd2, ... |

```

If no plugins are installed, display:

```
## Installed Plugins

No plugins installed.
To install a plugin: /plugin.install <name>
```

### 4. Display registered sources

If sources are registered, display them:

```
## Registered Sources

| Source | URL | Available Plugins |
|--------|-----|-------------------|
| <name> | <url> | <plugin1>, <plugin2>, ... |

```

If no sources are registered, display:

```
## Registered Sources

No sources registered.
To add a source: /plugin.marketplace-add <git-repo-url>
```

### 5. Display help

Always end with a brief help section:

```
## Commands

- `/plugin.marketplace-add <url>` — Register a plugin source
- `/plugin.install <name>` — Install a plugin
- `/plugin.uninstall <name>` — Remove a plugin
- `/plugin.list` — Show this information
```
