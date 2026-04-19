# detect-secrets Pre-Commit Hook Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Install `detect-secrets` as a `pre-commit` hook in the `config` and `picnic-config` repos, blocking commits that introduce new potential secrets.

**Architecture:** Each repo gets a `.pre-commit-config.yaml` and a committed `.secrets.baseline`. The `install-additional-apps` script installs `pipx`, `pre-commit`, and `detect-secrets`. The `install-post-configuration` script initializes baselines and activates hooks — both steps are idempotent.

**Tech Stack:** `pre-commit` framework, `detect-secrets` (Yelp), `pipx`

---

## File Map

| Action | Path |
|--------|------|
| Modify | `install-additional-apps` |
| Modify | `install-post-configuration` |
| Create | `.pre-commit-config.yaml` |
| Create | `picnic-config/.pre-commit-config.yaml` |
| Create | `.secrets.baseline` (generated, committed) |
| Create | `picnic-config/.secrets.baseline` (generated, committed) |

---

### Task 1: Add tool installation to `install-additional-apps`

**Files:**
- Modify: `install-additional-apps`

- [ ] **Step 1: Add pipx, pre-commit, and detect-secrets install block**

Open `install-additional-apps` and append the following block before the final newline:

```bash
if ! command -v pipx &>/dev/null; then
  echo "Installing pipx..."
  yay -S --noconfirm --needed python-pipx
fi

if ! command -v pre-commit &>/dev/null; then
  echo "Installing pre-commit..."
  pipx install pre-commit
fi

if ! command -v detect-secrets &>/dev/null; then
  echo "Installing detect-secrets..."
  pipx install detect-secrets
fi
```

- [ ] **Step 2: Verify the block is idempotent by dry-reading it**

Check: each install is guarded by `command -v`. Re-running the script when tools are present must skip the install silently. No action needed — just confirm the guards are in place.

- [ ] **Step 3: Commit**

```bash
git add install-additional-apps
git commit -m "Add pipx, pre-commit, and detect-secrets installation"
```

---

### Task 2: Create `.pre-commit-config.yaml` in `config` repo

**Files:**
- Create: `.pre-commit-config.yaml`

- [ ] **Step 1: Create the config file**

Create `/home/ccernat/projects/config/.pre-commit-config.yaml` with:

```yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.5.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

- [ ] **Step 2: Commit**

```bash
git add .pre-commit-config.yaml
git commit -m "Add detect-secrets pre-commit config"
```

---

### Task 3: Create `.pre-commit-config.yaml` in `picnic-config` submodule

**Files:**
- Create: `picnic-config/.pre-commit-config.yaml`

- [ ] **Step 1: Create the config file**

Create `/home/ccernat/projects/config/picnic-config/.pre-commit-config.yaml` with:

```yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.5.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

- [ ] **Step 2: Commit in submodule, then update parent**

```bash
cd /home/ccernat/projects/config/picnic-config
git add .pre-commit-config.yaml
git commit -m "Add detect-secrets pre-commit config"

cd /home/ccernat/projects/config
git add picnic-config
git commit -m "Update picnic-config submodule"
```

---

### Task 4: Update `install-post-configuration` to bootstrap hooks

**Files:**
- Modify: `install-post-configuration`

- [ ] **Step 1: Add baseline init and hook install block**

Append the following to the end of `install-post-configuration`:

```bash
echo "Setting up detect-secrets pre-commit hooks..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for repo in "$SCRIPT_DIR" "$SCRIPT_DIR/picnic-config"; do
  if [[ -d "$repo" ]]; then
    pushd "$repo"
    if [[ ! -f .secrets.baseline ]]; then
      echo "Initializing .secrets.baseline in $repo..."
      detect-secrets scan > .secrets.baseline
    fi
    pre-commit install
    popd
  fi
done
```

- [ ] **Step 2: Verify idempotency logic**

Check: `[[ ! -f .secrets.baseline ]]` prevents re-scanning if baseline exists. `pre-commit install` is safe to re-run (it overwrites the hook file). `[[ -d "$repo" ]]` skips gracefully if `picnic-config` is absent.

- [ ] **Step 3: Commit**

```bash
cd /home/ccernat/projects/config
git add install-post-configuration
git commit -m "Bootstrap detect-secrets hooks in post-configuration"
```

---

### Task 5: Bootstrap the current machine

This runs the setup manually for the existing machine (future machines use the scripts).

- [ ] **Step 1: Install pipx, pre-commit, detect-secrets**

```bash
yay -S --noconfirm --needed python-pipx
pipx install pre-commit
pipx install detect-secrets
```

Expected: all three install without error. Verify with:

```bash
pre-commit --version   # e.g. pre-commit 3.x.x
detect-secrets --version  # e.g. 1.5.0
```

- [ ] **Step 2: Initialize `.secrets.baseline` in `config` repo**

```bash
cd /home/ccernat/projects/config
detect-secrets scan > .secrets.baseline
```

Expected: `.secrets.baseline` created (JSON file listing any existing findings or an empty results map).

- [ ] **Step 3: Install the pre-commit hook in `config` repo**

```bash
pre-commit install
```

Expected output: `pre-commit installed at .git/hooks/pre-commit`

- [ ] **Step 4: Initialize `.secrets.baseline` in `picnic-config` submodule**

```bash
cd /home/ccernat/projects/config/picnic-config
detect-secrets scan > .secrets.baseline
```

- [ ] **Step 5: Install the pre-commit hook in `picnic-config`**

```bash
pre-commit install
```

Expected output: `pre-commit installed at .git/hooks/pre-commit`

- [ ] **Step 6: Commit baselines**

```bash
cd /home/ccernat/projects/config/picnic-config
git add .secrets.baseline
git commit -m "Add initial .secrets.baseline"

cd /home/ccernat/projects/config
git add .secrets.baseline picnic-config
git commit -m "Add initial .secrets.baseline and update submodule"
```

---

### Task 6: Verify the hook works end-to-end

- [ ] **Step 1: Stage a file with a fake secret**

```bash
cd /home/ccernat/projects/config
echo 'AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY' > /tmp/fake_secret.txt
cp /tmp/fake_secret.txt fake_secret_test.txt
git add fake_secret_test.txt
```

- [ ] **Step 2: Attempt to commit and confirm the hook blocks it**

```bash
git commit -m "test: should be blocked"
```

Expected: commit is **rejected** with output like:
```
Detect secrets...........................................................Failed
- hook id: detect-secrets
- exit code: 1
```
And `.secrets.baseline` is updated with the new finding.

- [ ] **Step 3: Clean up the test file**

```bash
git restore --staged fake_secret_test.txt
rm fake_secret_test.txt
```

- [ ] **Step 4: Confirm a clean commit passes**

```bash
echo "harmless content" > harmless.txt
git add harmless.txt
git commit -m "test: should pass"
```

Expected: hook passes, commit succeeds.

- [ ] **Step 5: Remove test file and commit**

```bash
git rm harmless.txt
git commit -m "Remove test file"
```

---

### Task 7: Push everything

- [ ] **Step 1: Push submodule**

```bash
cd /home/ccernat/projects/config/picnic-config
git push
```

- [ ] **Step 2: Push parent repo**

```bash
cd /home/ccernat/projects/config
git push
```
