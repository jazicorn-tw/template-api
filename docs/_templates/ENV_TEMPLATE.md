<!-- markdownlint-disable-file MD060 -->
<!-- markdownlint-disable-file MD036 -->
<!-- markdownlint-disable MD024 -->

# ✅ Variables & Environment Configuration

This document defines **CI feature flags** and **runtime environment variables**
used across local development, CI, and deployments (Render/Kubernetes/etc).

> **Security note**
> This file documents **names + behavior only**.
> Secret values must be managed via platform secret managers and **never committed**.

---

## ⚡ Environment Variables — Quick Reference

### 🔀 CI Feature Flags (GitHub Actions)

**Purpose:** Control CI publishing/deploy behavior without code changes.  
🔗 See details: **[CI Feature Flags](#-ci-feature-flags-github-actions)**

```text
PUBLISH_DOCKER_IMAGE   # optional — true|false — publish Docker image on release tags
CANONICAL_REPOSITORY  # required* — <owner>/<repo> — allowed publishing repo

PUBLISH_HELM_CHART    # optional — (future) publish Helm charts on release tags
DEPLOY_ENABLED        # optional — (future) global deploy kill switch
```

\* Required only when publishing is enabled (`PUBLISH_DOCKER_IMAGE=true`)

---

### 🌐 Runtime (All Platforms)

**Purpose:** Configure app behavior via 12-factor environment variables.  
🔗 See details: **[Runtime variables](#-runtime-environment-variables-all-platforms)**

```text
SPRING_PROFILES_ACTIVE   # required — dev|test|prod
SERVER_PORT              # optional
SPRING_DATASOURCE_URL        # required
SPRING_DATASOURCE_USERNAME  # required
SPRING_DATASOURCE_PASSWORD  # required — secret
JWT_SECRET                  # required — secret
JWT_EXPIRATION_SECONDS      # optional
MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE   # optional
MANAGEMENT_ENDPOINT_HEALTH_PROBES_ENABLED  # optional
```

---

## ✅ Minimal required per environment

Legend: ✅ required, ⚪ optional, — not applicable

| Variable | Local | CI | Prod (Platform A) | Prod (Platform B) | Notes |
| --- | ---: | ---: | ---: | ---: | ---: |
| `SPRING_PROFILES_ACTIVE` | ✅ | ✅ | ✅ | ✅ |  |
| `SERVER_PORT` | ⚪ | — | ⚪ | ⚪ |  |
| `SPRING_DATASOURCE_URL` | ✅ | ✅ | ✅ | ✅ |  |
| `SPRING_DATASOURCE_USERNAME` | ✅ | ✅ | ✅ | ✅ |  |
| `SPRING_DATASOURCE_PASSWORD` | ✅ | ✅ | ✅ | ✅ | secret |
| `JWT_SECRET` | ✅ | ✅ | ✅ | ✅ | secret |
| `JWT_EXPIRATION_SECONDS` | ⚪ | ⚪ | ⚪ | ⚪ |  |
| `MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE` | ⚪ | ⚪ | ⚪ | ⚪ |  |
| `MANAGEMENT_ENDPOINT_HEALTH_PROBES_ENABLED` | ⚪ | ⚪ | ⚪ | ✅ |  |

---

## 🔀 CI Feature Flags (GitHub Actions)

Create these under:

**Settings → Secrets and variables → Actions → Variables**

### Docker image publishing

- `PUBLISH_DOCKER_IMAGE` = `true` | `false`
- `CANONICAL_REPOSITORY` = `<owner>/<repo>`

**Publishing requires both:**

1. `PUBLISH_DOCKER_IMAGE == true`
2. Running in `CANONICAL_REPOSITORY`

Used by:

- `.github/workflows/publish-image.yml`

---

## 🌐 Runtime Environment Variables (All Platforms)

### Application runtime

| Variable | Required | Description |
| --- | ---: | --- |
| `SPRING_PROFILES_ACTIVE` | ✅ | Active profile |
| `SERVER_PORT` | ❌ | Port override |

### Database

| Variable | Required | Description |
| --- | ---: | --- |
| `SPRING_DATASOURCE_URL` | ✅ | JDBC URL |
| `SPRING_DATASOURCE_USERNAME` | ✅ | DB user |
| `SPRING_DATASOURCE_PASSWORD` | ✅ | DB password (secret) |

### Security

| Variable | Required | Description |
| --- | ---: | --- |
| `JWT_SECRET` | ✅ | JWT signing secret (secret) |
| `JWT_EXPIRATION_SECONDS` | ❌ | Token lifetime override |

### Observability

| Variable | Required | Description |
| --- | ---: | --- |
| `MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE` | ❌ | Exposed actuator endpoints |
| `MANAGEMENT_ENDPOINT_HEALTH_PROBES_ENABLED` | ❌ | readiness/liveness probes |

---

## ✅ Enforcement (recommended)

- Startup validation: fail fast if required vars are missing.
- CI validation: script step to verify required vars exist before build/test.
