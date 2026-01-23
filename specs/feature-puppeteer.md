# Puppeteer Feature Specification

## Location

`features/puppeteer/`

## Structure

```
features/puppeteer/
├── devcontainer-feature.json
└── install.sh
```

## Options

None. Installs Chromium by default.

## Installation

1. Installs Chromium and system dependencies
2. Sets environment variables for Puppeteer to use system Chromium
3. Installs puppeteer-mcp (Model Context Protocol server for browser automation)

**System dependencies:**
- chromium
- libnss3, libatk-bridge2.0-0, libdrm2, libxkbcommon0, libgbm1, libasound2
- libxss1, libgtk-3-0
- Fonts: fonts-ipafont-gothic, fonts-wqy-zenhei, fonts-thai-tlwg, fonts-kacst, fonts-freefont-ttf

## Puppeteer MCP

Installs the puppeteer-mcp server at `/home/dev/puppeteer-mcp` for browser automation via the Model Context Protocol.

## Environment Variables

- `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true` - don't download bundled Chromium
- `PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium` - use system Chromium

## Dependencies

Requires Node.js. Should be declared in `installsAfter` to ensure proper ordering.

## Usage

```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/puppeteer:1": {}
  }
}
```

## Size Impact

Adds ~400MB for Chromium and dependencies.

## Proxy Considerations

Puppeteer respects proxy environment variables set in the base template.
