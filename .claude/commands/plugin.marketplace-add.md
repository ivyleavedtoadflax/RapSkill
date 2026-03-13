---
description: Register a Git repository as a plugin source for Claude Code skills. Use this to add plugin marketplaces that contain installable skill packages.
---

## User Input

```text
$ARGUMENTS
```

## Outline

Register a Git repository as a plugin source so its plugins can be installed with `/plugin.install`.

### 1. Parse the repository URL

Extract the Git repository URL from `$ARGUMENTS`. If no URL is provided, display an error:

```
Error: No repository URL provided.
Usage: /plugin.marketplace-add <git-repo-url>
Example: /plugin.marketplace-add https://github.com/org/my-plugins
```

### 2. Validate the URL

Check that the URL looks like a valid Git repository URL (starts with `https://` or `git@`). If invalid, display an error with the expected format.

### 3. Check if already registered

Read `.claude/plugins/sources.json`. If the file does not exist, create it with an empty array `[]`.

Check if the URL (normalized — strip trailing `.git` and `/` for comparison) is already in the sources list. If already registered, inform the user and list the plugins from that source.

### 4. Clone/fetch the repository

Use the Bash tool to clone the repository to a temporary directory:

```bash
TEMP_DIR=$(mktemp -d)
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>&1
```

If the clone fails, display an error suggesting the URL may be incorrect or the repository may be private.

### 5. Discover plugins

Search for `manifest.yml` files in the cloned repository:

```bash
find "$TEMP_DIR/plugins" -name "manifest.yml" -type f 2>/dev/null
```

For each manifest found, read its contents and extract: name, version, description, and commands list.

If no manifests found, inform the user that the repository does not contain any plugins.

### 6. Register the source

Read the current `.claude/plugins/sources.json`, append the new source entry:

```json
{
  "url": "<repo-url>",
  "name": "<derived-from-repo-name>",
  "added_at": "<ISO-date>",
  "plugins": [
    {
      "name": "<plugin-name>",
      "version": "<version>",
      "description": "<description>",
      "commands": ["<cmd1>", "<cmd2>"]
    }
  ]
}
```

Write the updated array back to `.claude/plugins/sources.json`.

### 7. Clean up and report

Remove the temporary clone directory:

```bash
rm -rf "$TEMP_DIR"
```

Display a success message listing the registered source and available plugins:

```
Plugin source registered: <repo-url>

Available plugins:
  - <plugin-name> v<version>: <description>
    Commands: /cmd1, /cmd2, ...

To install a plugin: /plugin.install <plugin-name>
```

## Error Handling

- No URL provided: show usage instructions
- Invalid URL format: show expected formats
- Clone fails: suggest checking URL, network, or repository access
- No manifests found: inform user the repo has no plugins
- Already registered: show existing plugins from that source
