# What does each CI workflow do?

This article describes every GitHub Actions workflow in this project — when it
runs, what it checks, and what can skip or gate it.

---

## Workflow overview

| Workflow file | Name | Trigger |
| ------------- | ---- | ------- |
| `ci-fast.yml` | CI Fast | All PRs, manual |
| `ci-quality.yml` | CI Quality | All PRs, push to `main`/`staging`/`dev`, manual |
| `ci-test.yml` | CI Test | All PRs, push to `main`/`staging`/`dev`, manual |
| `codeql.yml` | CodeQL | All PRs, push to `main`/`staging`/`dev`, weekly schedule, manual |
| `image-build.yml` | Build Image | PRs and push to `main`/`staging`/`dev`/`canary` (path-filtered) |
| `release.yml` | Release | Push to `main`/`canary` (gated), manual |
| `ci-guard-release-artifacts.yml` | CI Guard Release Artifacts | All PRs and pushes |
| `doctor-snapshot.yml` | Doctor | All PRs, push to `main`, manual |
| `ci-failure-comment.yml` | CI Failure Helper Comment | After CI run completes with failure |

---

## ci-fast — Compile + unit tests

**Triggers:** all PRs, `workflow_dispatch`

The fastest feedback loop. Two jobs:

1. **`fast`** — compiles the project and runs all tests (including
   Testcontainers integration tests) on every PR. No static analysis, no
   SonarCloud, no Docker image build.

2. **`planning-lint`** — runs after `fast`; lints `IDEAS.md`, `TODO.md`, and
   `PROMOTION_CHECKLIST.md` using `scripts/planning/planning-lint.sh`.

This workflow is intentionally lean. It must pass on every PR before merge.

---

## ci-quality — Static analysis + SonarCloud

**Triggers:** all PRs, push to `main`/`staging`/`dev`, `workflow_dispatch`

Two parallel jobs:

1. **`quality`** — runs in order:
   - `spotlessCheck` — formatting (fails fast if files are not formatted)
   - `checkstyleMain`, `checkstyleTest`, `pmdMain`, `pmdTest`,
     `spotbugsMain`, `spotbugsTest` — gated by `ENABLE_STATIC_ANALYSIS != 'false'`
   - SonarCloud analysis — gated by `ENABLE_SONAR != 'false'` and
     requires `SONAR_TOKEN`; skipped under `act`

2. **`markdown-lint`** — runs `markdownlint-cli2` against all `*.md` files in
   the repo; gated by `ENABLE_MD_LINT != 'false'`

No Docker required. Runs without Testcontainers.

---

## ci-test — Integration tests

**Triggers:** all PRs, push to `main`/`staging`/`dev`, `workflow_dispatch`

Single job:

- Starts Docker (GitHub-hosted runners have Docker pre-installed)
- Runs `./gradlew test` — includes Testcontainers integration tests
- Uploads test reports as a build artifact on failure

This is the authoritative test run for branches. `ci-fast` also runs tests,
but `ci-test` is the dedicated job with Docker availability confirmed and
failure artifacts uploaded.

---

## codeql — Security analysis

**Triggers:** all PRs, push to `main`/`staging`/`dev`, weekly schedule (Monday
03:00 UTC), `workflow_dispatch`

**Gated:** skipped when `ENABLE_CODEQL=false` or when running under `act`.

Single job:

- Initializes CodeQL for `java-kotlin` with the `security-and-quality` query
  suite
- Builds the project via CodeQL autobuild (no Docker required)
- Uploads results as SARIF to the **Security → Code scanning** tab

On PRs, CodeQL posts inline annotations on changed lines where issues are found
— similar to SonarCloud PR decoration but native to GitHub with no external
service required.

The weekly schedule catches new vulnerability rules published between pushes.

**To enable:** no variables need to be set — CodeQL runs by default. Requires
`security-events: write` permission, which is already declared in the workflow.
For private repositories, GitHub Advanced Security must be enabled on the repo.

**To disable:**

```text
Settings → Variables → Actions → ENABLE_CODEQL = false
```

---

## image-build — Docker image and Helm lint

**Triggers:** PRs targeting `main`/`staging`/`dev`/`canary`, push to those
branches; path-filtered to `Dockerfile`, `src/**`, `build.gradle`,
`settings.gradle`, `gradle/**`, `helm/**`

Two parallel jobs:

1. **`build`** — builds the Docker image (`push: false`) to verify the
   `Dockerfile` compiles correctly. No image is pushed.

2. **`helm-lint`** — runs `helm lint helm/app` to validate the Helm chart
   template.

Changes to documentation, scripts, or workflow files do not trigger this
workflow.

---

## release — Semantic-release + artifact publishing

**Triggers:** push to `main` or `canary`; `workflow_dispatch` with
`enable_release=true`

**Gated:** requires `ENABLE_SEMANTIC_RELEASE=true` (repo variable) or manual
input.

Two jobs:

1. **`release`** — runs semantic-release:
   - Dry-runs first to preview the next version
   - Under `act`: always dry-run only (no publish)
   - On GitHub: publishes if releasable commits exist (`feat:`, `fix:`,
     `perf:`)
   - Writes a job summary with gate values and outcome

2. **`publish`** — runs after `release`, only in the canonical repository and
   only when a version was published:
   - Docker image → GHCR, gated by `PUBLISH_DOCKER_IMAGE=true`
   - Helm chart → GHCR OCI, gated by `PUBLISH_HELM_CHART=true`

See [`WHY_NO_RELEASE.md`](./WHY_NO_RELEASE.md) for the full release diagnosis
guide.

---

## ci-guard-release-artifacts — CHANGELOG protection

**Triggers:** all PRs and all pushes (no branch filter)

Prevents manual edits to `CHANGELOG.md`. Rules:

- **PRs** — any PR that modifies `CHANGELOG.md` fails
- **Pushes to non-`main` branches** — modification blocked
- **Pushes to `main`** — allowed only if the commit message matches
  `chore(release): X.Y.Z [skip ci]` and the author is a recognized bot

Can be disabled via `GUARD_RELEASE_ARTIFACTS=false` (repo variable).

---

## doctor-snapshot — Environment validation

**Triggers:** all PRs, push to `main`, `workflow_dispatch`

Runs `scripts/doctor.sh --json --allow-ci` and validates the output:

- Checks required JSON fields: `status`, `os`, `git_branch`, `java_major`,
  `docker_provider`, `warnings`, `errors`
- Fails if `status=fail`
- Emits GitHub annotations for each warning and error
- Uploads `build/doctor/doctor.json` as a build artifact (14-day retention)

Can be disabled via `ENABLE_DOCTOR_SNAPSHOT=false` (repo variable).

---

## ci-failure-comment — PR helper comment

**Triggers:** after a workflow named `CI` completes with a non-success result
on a pull request

Posts (or updates) a single comment on the PR linking to the First PR Smoke
Test checklist. Uses an idempotent marker so the comment is updated in place
rather than duplicated on every failure.

This workflow does not run any tests. It only writes a comment.

---

## Feature flags summary

Most workflows respect repository variables that let you disable expensive or
optional steps. See
[`docs/environment/ci/CI_FEATURE_FLAGS.md`](../environment/ci/CI_FEATURE_FLAGS.md)
for the complete list.

| Variable | Default | Controls |
| -------- | ------- | -------- |
| `ENABLE_CODEQL` | on | CodeQL analysis job in `codeql` |
| `ENABLE_STATIC_ANALYSIS` | on | Checkstyle/PMD/SpotBugs in `ci-quality` |
| `ENABLE_SONAR` | on | SonarCloud analysis in `ci-quality` |
| `ENABLE_MD_LINT` | on | markdownlint job in `ci-quality` |
| `ENABLE_SEMANTIC_RELEASE` | off | Release job in `release` |
| `PUBLISH_DOCKER_IMAGE` | off | Docker publish in `release` |
| `PUBLISH_HELM_CHART` | off | Helm publish in `release` |
| `GUARD_RELEASE_ARTIFACTS` | on | CHANGELOG guard in `ci-guard-release-artifacts` |
| `ENABLE_DOCTOR_SNAPSHOT` | on | `doctor-snapshot` workflow |

---

## Related

- [`WHY_NO_RELEASE.md`](./WHY_NO_RELEASE.md) —
  Diagnosing why a release was not created
- [`SONARCLOUD_EXPLAINED.md`](./SONARCLOUD_EXPLAINED.md) —
  SonarCloud setup and quality gate details
- [`docs/devops/BRANCH_FLOW.md`](../devops/BRANCH_FLOW.md) —
  Which workflows trigger on which branches
- [`docs/environment/ci/CI_FEATURE_FLAGS.md`](../environment/ci/CI_FEATURE_FLAGS.md) —
  Full feature flag reference
