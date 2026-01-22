# Architecture Specification

## Overview

This repository provides a base Dev Container template with optional features for Node.js, Python, and browser automation. Traffic is filtered through a shared Squid proxy with iptables firewall enforcement.

## Components

### 1. Base Template (`templates/base/`)

A general-purpose development container. Built locally when applied to projects.

**Responsibilities:**
- Common OS layer (Debian bookworm-slim)
- Shell environment (zsh with powerlevel10k)
- Essential tools (git, curl, git-delta, etc.)
- Firewall enforcement (iptables)
- Proxy environment configuration

### 2. Features (`features/`)

Installable capabilities that extend the base template.

| Feature | Purpose |
|---------|---------|
| `node` | Node.js runtime with npm |
| `python` | Python runtime with uv |
| `puppeteer` | Headless browser automation |

### 3. Squid Proxy (`squid/`)

Shared infrastructure for traffic filtering. Runs independently, devcontainers connect via external Docker network.

**Purpose:**
- Filter outbound traffic for AI agent isolation
- Allow only whitelisted domains

## Security Model

Traffic filtering uses two layers:

1. **Squid proxy** - Whitelists allowed domains
2. **iptables firewall** - Blocks ALL outbound traffic except to Squid

This prevents bypass via direct connections or tools that ignore proxy settings.

```
┌─────────────────────────────────────────────────────────┐
│                    Devcontainer                         │
│                                                         │
│  ┌─────────────┐     ┌─────────────┐                   │
│  │ Application │────▶│  iptables   │                   │
│  └─────────────┘     │  firewall   │                   │
│                      └──────┬──────┘                   │
│                             │ ONLY squid:3128 allowed  │
└─────────────────────────────┼───────────────────────────┘
                              │
                              ▼
                      ┌─────────────┐
                      │    Squid    │
                      │   (filter)  │
                      └──────┬──────┘
                             │
                             ▼
                      ┌─────────────┐
                      │  Internet   │
                      │ (whitelist) │
                      └─────────────┘
```

## Publishing Strategy

| Component | Published To | Versioning |
|-----------|--------------|------------|
| Base template | `ghcr.io/gus-costa/devcontainers/base` | `major.minor` |
| Features | `ghcr.io/gus-costa/devcontainers/features/` | `major.minor.patch` |
| Squid | Not published | N/A |

Base image is built locally from the template's Dockerfile.
