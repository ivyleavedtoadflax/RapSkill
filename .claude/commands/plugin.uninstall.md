---
description: Uninstall a previously installed plugin. Removes skill files from your project and updates the plugin registry.
---

## User Input

```text
$ARGUMENTS
```

## Outline

Remove an installed plugin and its skill files.

### 1. Parse the plugin name

Extract the plugin name from `$ARGUMENTS`. If no name is provided, display an error:

```
Error: No plugin name provided.
Usage: /plugin.uninstall <plugin-name>
Example: /plugin.uninstall rap

To see installed plugins: /plugin.list
```

### 2. Check if the plugin is installed

Read `.claude/plugins/registry.json`. If the file does not exist or is empty, display:

```
Error: No plugins are currently installed.
```

Look up the plugin name in the registry. If not found, display:

```
Error: Plugin "<name>" is not installed.

Installed plugins:
  - <list installed plugins>

To see available plugins: /plugin.list
```

### 3. Remove skill files

For each command listed in the plugin's registry entry `commands` array:

1. Check if `.claude/commands/<command-name>.md` exists
2. If it exists, delete it using the Bash tool: `rm .claude/commands/<command-name>.md`
3. Track which files were successfully removed and which were already missing

### 4. Update the registry

Read `.claude/plugins/registry.json`, remove the entry for the uninstalled plugin, and write the updated registry back.

### 5. Report

Display a success message:

```
Plugin "<name>" uninstalled successfully.

Removed commands:
  - /cmd1
  - /cmd2
  ...

The plugin source is still registered. To reinstall: /plugin.install <name>
```

## Error Handling

- No plugin name provided: show usage instructions
- Plugin not installed: list currently installed plugins
- Skill file already missing: note it was already removed, continue with others
- Registry file missing: inform user no plugins are installed
