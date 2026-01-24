# Squid Proxy Specification

## Location

`squid/`

## Structure

```
squid/
├── docker-compose.yml
└── squid.conf
```

## Purpose

Network traffic filtering for AI agent isolation. All devcontainer traffic routes through Squid, which allows only whitelisted domains.

## Network

**Network name:** `devcontainer-proxy`

Created by Squid's compose file. Devcontainers join as external network.

**Container image:** `ubuntu/squid:latest`

**Container name:** `devcontainer-squid`

**Port:** 3128

## Configuration Structure

The `squid.conf` uses ACLs (Access Control Lists):

**Network ACL:**
- Allow Docker internal networks (172.16.0.0/12, 192.168.0.0/16, 10.0.0.0/8)

**Domain whitelist categories:**

| Category | Domains |
|----------|---------|
| GitHub | .github.com, .githubusercontent.com |
| npm | registry.npmjs.org |
| Python/uv | .pypi.org, .pythonhosted.org |
| Claude | api.anthropic.com, sentry.io, statsig.anthropic.com, statsig.com, platform.claude.com |
| VS Code | main.vscode-cdn.net, .vscode-unpkg.net, marketplace.visualstudio.com, .gallery.vsassets.io, .gallerycdn.vsassets.io |

**Rule order:**
1. Allow localnet + whitelisted domains
2. Deny all else

**Privacy settings:**
- `via off` - don't add Via header
- `forwarded_for off` - don't expose client IP

**Logging:**
- Custom format with full URL, timestamps, status codes
- Logs to `/var/log/squid/access.log`

**Cache:**
- Cache directory at `/var/spool/squid`
- Persisted via Docker volume

## Volumes

- `squid-cache` - persistent cache for performance
- Config mounted from host for easy editing

## Lifecycle

**Start:**
```bash
docker compose -f squid/docker-compose.yml up -d
```

**Stop:**
```bash
docker compose -f squid/docker-compose.yml down
```

**Logs:**
```bash
docker logs devcontainer-squid
```

**Check access log:**
```bash
docker exec devcontainer-squid tail -f /var/log/squid/access.log
```

## Adding Domains

Edit `squid.conf`, add new ACL line:
```
acl whitelisted_domains dstdomain .example.com
```

Then restart:
```bash
docker compose -f squid/docker-compose.yml restart
```

## Important Notes

- Squid must be running before starting devcontainers
- All devcontainers share the same Squid instance
- Devcontainers use iptables to enforce proxy-only traffic
