# 📦 Release History

## 📦 Release 0.1.0

### ✨ Features

- add canary pre-release channel and fix workflow placeholders (f6714bf)
- **dx:** add editorconfig, security policy, jacoco threshold, sonar exclusions, helm resources, arm64 docker (66d61c7)

### 🐛 Fixes

- **ci:** extract Docker and Helm publishing to publish.yml (8a89329)
- **ci:** fail fast on helm registry login error (7bc42d5)
- **ci:** fix publish job skipped on tag push (dd23f56)
- **ci:** publish only on tag push (35f47a1)
- **dx:** fix pre-add hook skipping single-file git add (f548544)
- **dx:** list lint-docs files one per line in pre-add output (fe9ef33)
- harden application.properties production defaults (c6bbf72)
- **helm:** replace project-name placeholders and clarify Chart.yaml version comment (80d2955)
- **hooks:** lint only staged markdown files in pre-add hook (6ae7479)

### 🤖 CI / CD

- add GitHub variables to enable/disable CI jobs and steps (e8be340)
- consolidate 10 workflows into 6 with flat semantic naming (62ff76a)

### 🧹 Chores

- add Dependabot, SECURITY policy, issue templates, fix CI flags doc (0f87478)
- **ci:** drop dev branch and fix release job gating (cd8324f)
- comment out CI badge until repo is configured (d298480)
- **docs:** normalize all markdown tables to compact pipe style (0707b2c)
- **dx:** replace CI baseline tag automation with pre-push hook (2d9b2e2)

### ♻️ Refactors

- simplify scaffold to single resource entity and improve docs (283a246)

### 📝 Docs

- add 5 FAQ articles covering release gating, H2, pre-add hook, SonarCloud, and CI workflows (0c40447)
- add FAQ articles explaining application.properties pitfalls (b37ffa4)
- add GitHub App bypass setup guide and expand RELEASE.md Step 3 (84a18e2)
- **ci:** update docs to reflect publish.yml extraction (976c03b)
- document CI feature flags, GitHub App setup, and .vars.example updates (4bafc0c)
- document CodeQL workflow, ENABLE_CODEQL flag, and security scanning (62d693a)
- **github-app:** add Workflows permission requirement to setup guide (ced91e9)
- reorganize FAQ into subfolders and expand GitHub App key documentation (153fbb8)
- update docs to reflect arm64, jacoco threshold, helm resources, and init-project script (3345e62)



## 0.1.0

### ✨ Features

- add canary pre-release channel and fix workflow placeholders
- **dx:** add editorconfig, security policy, jacoco threshold, sonar exclusions, helm resources, arm64 docker

### 🐛 Fixes

- **ci:** extract Docker and Helm publishing to publish.yml
- **ci:** fail fast on helm registry login error
- **ci:** fix publish job skipped on tag push
- **ci:** publish only on tag push
- **dx:** fix pre-add hook skipping single-file git add
- **dx:** list lint-docs files one per line in pre-add output
- harden application.properties production defaults
- **helm:** replace project-name placeholders and clarify Chart.yaml version comment
- **hooks:** lint only staged markdown files in pre-add hook

### 🤖 CI / CD

- add GitHub variables to enable/disable CI jobs and steps
- consolidate 10 workflows into 6 with flat semantic naming

### 🧹 Chores

- add Dependabot, SECURITY policy, issue templates, fix CI flags doc
- **ci:** drop dev branch and fix release job gating
- comment out CI badge until repo is configured
- **docs:** normalize all markdown tables to compact pipe style
- **dx:** replace CI baseline tag automation with pre-push hook

### ♻️ Refactors

- simplify scaffold to single resource entity and improve docs

### 📝 Docs

- add 5 FAQ articles covering release gating, H2, pre-add hook, SonarCloud, and CI workflows
- add FAQ articles explaining application.properties pitfalls
- add GitHub App bypass setup guide and expand RELEASE.md Step 3
- **ci:** update docs to reflect publish.yml extraction
- document CI feature flags, GitHub App setup, and .vars.example updates
- document CodeQL workflow, ENABLE_CODEQL flag, and security scanning
- **github-app:** add Workflows permission requirement to setup guide
- reorganize FAQ into subfolders and expand GitHub App key documentation
- update docs to reflect arm64, jacoco threshold, helm resources, and init-project script
