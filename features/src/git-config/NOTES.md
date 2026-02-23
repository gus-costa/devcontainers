## How it works

1. Mounts the host's `~/.gitconfig` as read-only at `/tmp/host.gitconfig`
2. Uses a `postStartCommand` to copy it to the container user's home directory (`~/.gitconfig`)

## Notes

- The mount is read-only to prevent accidental modifications to the host's git configuration
- If the host's `.gitconfig` doesn't exist, the copy command will silently fail without breaking the container startup
