# 📦 Release History

## 📦 Release 0.1.0

### ✨ Features

- add canary pre-release channel and fix workflow placeholders (f6714bf)

### 🐛 Fixes

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
- document CI feature flags, GitHub App setup, and .vars.example updates (4bafc0c)
- document CodeQL workflow, ENABLE_CODEQL flag, and security scanning (62d693a)
- **github-app:** add Workflows permission requirement to setup guide (ced91e9)
- reorganize FAQ into subfolders and expand GitHub App key documentation (153fbb8)



## 0.1.0

### ✨ Features

- add canary pre-release channel and fix workflow placeholders

### 🐛 Fixes

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
- document CI feature flags, GitHub App setup, and .vars.example updates
- document CodeQL workflow, ENABLE_CODEQL flag, and security scanning
- **github-app:** add Workflows permission requirement to setup guide
- reorganize FAQ into subfolders and expand GitHub App key documentation
