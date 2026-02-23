
# Git Config (git-config)

Copies host's .gitconfig into the container

## Example Usage

```json
"features": {
    "ghcr.io/gus-costa/devcontainers/features/git-config:1": {}
}
```



## How it works

1. Mounts the host's `~/.gitconfig` as read-only at `/tmp/host.gitconfig`
2. Uses a `postStartCommand` to copy it to the container user's home directory (`~/.gitconfig`)

## Notes

- The mount is read-only to prevent accidental modifications to the host's git configuration
- If the host's `.gitconfig` doesn't exist, the copy command will silently fail without breaking the container startup


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/gus-costa/devcontainers/blob/main/features/src/git-config/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
