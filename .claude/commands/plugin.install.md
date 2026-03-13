---
description: Install a plugin from a registered plugin source. Copies skill files into your project and records the installation. Use /plugin.marketplace-add first to register a source.
---

## User Input

```text
$ARGUMENTS
```

## Outline

Install a plugin by name from a previously registered plugin source.

### 1. Parse the plugin name

Extract the plugin name from `$ARGUMENTS`. If no name is provided, display an error:

```
Error: No plugin name provided.
Usage: /plugin.install <plugin-name>
Example: /plugin.install rap

To see available plugins: /plugin.list
```

### 2. Load registered sources

Read `.claude/plugins/sources.json`. If the file does not exist or is empty, display:

```
Error: No plugin sources registered.
First register a source: /plugin.marketplace-add <git-repo-url>
```

### 3. Find the plugin in registered sources

Search through all registered sources for a plugin matching the requested name. Check each source's `plugins` array for a matching `name` field.

If not found, display:

```
Error: Plugin "<name>" not found in any registered source.

Available plugins:
  - <list plugins from all sources>

To add more sources: /plugin.marketplace-add <git-repo-url>
```

### 4. Check if already installed

Read `.claude/plugins/registry.json`. If the file does not exist, create it with an empty object `{}`.

If the plugin is already installed, display:

```
Plugin "<name>" is already installed (v<version>).
Installed commands: /cmd1, /cmd2, ...

To reinstall, first run: /plugin.uninstall <name>
```

### 5. Clone the source repository

Clone the source repository to a temporary directory to access the plugin files:

```bash
TEMP_DIR=$(mktemp -d)
git clone --depth 1 "<source-url>" "$TEMP_DIR" 2>&1
```

### 6. Read the plugin manifest

Read the manifest file from the cloned repository at `$TEMP_DIR/plugins/<plugin-name>/manifest.yml`.

Verify that all command files listed in the manifest exist in the cloned repository.

### 7. Copy skill files

For each command in the manifest's `commands` array:

1. Read the skill file from `$TEMP_DIR/plugins/<plugin-name>/<file-path>`
2. Check if a file with the same command name already exists in `.claude/commands/`. If it does and belongs to a different plugin, warn about the conflict and skip that command.
3. Write the skill file to `.claude/commands/<command-name>.md`

### 8. Record the installation

Update `.claude/plugins/registry.json` by adding an entry for the installed plugin:

```json
{
  "<plugin-name>": {
    "name": "<plugin-name>",
    "version": "<version>",
    "source_url": "<source-url>",
    "installed_at": "<ISO-date>",
    "commands": ["<cmd1>", "<cmd2>", ...]
  }
}
```

### 9. Clean up and report

Remove the temporary clone directory:

```bash
rm -rf "$TEMP_DIR"
```

Display a success message:

```
Plugin "<name>" v<version> installed successfully!

Installed commands:
  /cmd1 — <description>
  /cmd2 — <description>
  ...

You can now use these commands in Claude Code.
To uninstall: /plugin.uninstall <name>
```

## Error Handling

- No plugin name provided: show usage instructions
- No sources registered: suggest `/plugin.marketplace-add`
- Plugin not found: list available plugins from all sources
- Already installed: show current version and suggest uninstall first
- Clone fails: suggest checking network or source URL
- Command name conflict: warn and skip conflicting commands
- Missing skill files in source: warn about missing files, install available ones
