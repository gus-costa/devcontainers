# Testing Specification

## Location

- Feature tests: `test/`
- Base template tests: `images/base/test-project/`

## Structure

```
test/
├── node/
│   ├── node.sh
│   ├── scenarios.json
│   └── test.sh
└── python/
    ├── python.sh
    ├── scenarios.json
    └── test.sh

images/base/test-project/
├── test.sh
└── test-utils.sh
```

## Test Scenarios

Tests use the devcontainer CLI test framework with `dev-container-features-test-lib`.

### Base Template

Test utilities in `images/base/test-project/`:
- `test-utils.sh` - Common test functions (check, checkOSPackages, reportResults)
- `test.sh` - Base image validation tests

### Node Feature

Files in `test/node/`:
- `test.sh` - Default feature tests (no options)
- `node.sh` - Scenario-specific tests
- `scenarios.json` - Version configuration tests (e.g., Node 24)

### Python Feature

Files in `test/python/`:
- `test.sh` - Default feature tests (no options)
- `python.sh` - Scenario-specific tests
- `scenarios.json` - Version configuration tests (e.g., Python 3.13)

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
