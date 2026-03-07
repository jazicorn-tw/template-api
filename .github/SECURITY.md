# Security Policy

## Supported versions

| Version | Supported |
| ------- | --------- |
| latest `main` | ✅ |
| older tags | ❌ |

## Reporting a vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Report security issues privately via
[GitHub Security Advisories](../security/advisories/new).

Include:

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (optional)

You will receive a response within **5 business days**. If the issue is
confirmed, a fix will be prioritized and a CVE requested if applicable.

## Security design

This project uses a phased security model:

- **Phase 0–5:** All endpoints publicly accessible (scaffold / development phase)
- **Phase 6:** Spring Security infrastructure added (inactive)
- **Phase 7:** JWT authentication enforced — unauthenticated requests return 401

See [`docs/devops/SECURITY.md`](../docs/devops/SECURITY.md) and
[`docs/adr/ADR-005-security-phased.md`](../docs/adr/ADR-005-security-phased.md)
for the full security design and rationale.

## Dependency updates

Dependencies are monitored automatically via Dependabot (weekly scans for
GitHub Actions, Gradle, and npm). CVE alerts are reviewed and patched promptly.
