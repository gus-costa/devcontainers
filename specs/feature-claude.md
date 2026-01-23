# Claude Feature Specification

## Location

`features/claude/`

## Structure

```
features/claude/
├── claude-init-config.json
├── devcontainer-feature.json
└── install.sh
```

## Options

None.

## Installation

Installs Claude Code CLI via the official installer script from `https://claude.ai/install.sh`.

Creates the `.claude` directory structure in the user's home directory.

Copies a pre-configured `~/.claude.json` with settings optimized for devcontainer use:
- Auto-updates enabled
- Onboarding marked as completed
- Auto-compact disabled

## VS Code Extensions

Automatically installs:
- anthropic.claude-code

## Mounts

Configures volumes and bind mounts to share Claude configuration from the host:

**Volume:**
- `claude-code-config` mounted at `/home/dev/.claude` for persistent data

**Bind mounts from host `~/.claude/`:**
- `CLAUDE.md` - Custom instructions
- `agents/` - Custom agents
- `commands/` - Custom commands
- `hooks/` - Hook scripts
- `settings.json` - User settings
- `devcontainer-data/.credentials.json` - API credentials

## Usage

```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/claude:1": {}
  }
}
```

## Proxy Considerations

Claude Code respects proxy environment variables set by the proxy feature.
