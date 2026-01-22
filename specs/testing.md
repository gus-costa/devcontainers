# Testing Specification

## Location

`test/`

## Structure

```
test/
├── base/
│   └── .devcontainer/
│       └── devcontainer.json
├── node/
│   └── .devcontainer/
│       └── devcontainer.json
└── python/
    └── .devcontainer/
        └── devcontainer.json
```

## Test Scenarios

### 1. Base Template
- Container builds successfully
- zsh is default shell with powerlevel10k
- Proxy environment variables are set
- Firewall blocks direct connections
- Firewall allows proxy connections

### 2. Node Feature
- Node.js installs at specified version
- npm works through proxy

### 3. Python Feature
- Python installs at specified version
- uv works through proxy

### 4. Puppeteer Feature
- Chromium installs correctly
- Can run headless browser

## Manual Testing Workflow

1. Start Squid
2. Open test project in VS Code
3. Reopen in Container
4. Verify runtime versions and proxy connectivity

## Firewall Verification

Inside container, verify firewall is working:

**Should fail (direct connection):**
```bash
curl --noproxy '*' --connect-timeout 3 https://api.github.com/zen
```

**Should fail (blocked domain):**
```bash
curl --connect-timeout 3 https://example.com
```

**Should succeed (allowed domain via proxy):**
```bash
curl --connect-timeout 3 https://api.github.com/zen
```
