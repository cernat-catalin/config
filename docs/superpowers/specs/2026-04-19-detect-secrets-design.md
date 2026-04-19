# detect-secrets Pre-Commit Hook Design

## Goal

Run `detect-secrets` as a pre-commit hook in the `config` and `picnic-config` repos.
When new potential secrets are detected, the commit is blocked and the findings are
added to a per-repo `.secrets.baseline` for manual review.

## Components

### 1. `.pre-commit-config.yaml` (both repos)

Declares the `detect-secrets` hook with a pinned version. Lives in the root of each repo
and is committed to version control.

```yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.5.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

### 2. `.secrets.baseline` (both repos)

Generated once via `detect-secrets scan > .secrets.baseline` and committed. Acts as the
known-good snapshot. Updated automatically when new findings are detected during a commit.

### 3. `install-additional-apps` (updated)

Installs `pre-commit` and `detect-secrets` via `pipx`. Idempotent: guarded with
`command -v` checks so re-running the script is safe.

```bash
if ! command -v pre-commit &>/dev/null; then
  pipx install pre-commit
fi

if ! command -v detect-secrets &>/dev/null; then
  pipx install detect-secrets
fi
```

### 4. `install-post-configuration` (updated)

For both `config` and `picnic-config`:

- Initializes `.secrets.baseline` if not present (idempotent: `[[ ! -f .secrets.baseline ]]` guard).
- Runs `pre-commit install` (idempotent: safe to re-run).

```bash
for repo in /home/ccernat/projects/config /home/ccernat/projects/config/picnic-config; do
  pushd "$repo"
  [[ ! -f .secrets.baseline ]] && detect-secrets scan > .secrets.baseline
  pre-commit install
  popd
done
```

## Commit Flow

1. `git commit` triggers the `pre-commit` hook.
2. `detect-secrets-hook` scans only staged files against `.secrets.baseline`.
3. **No new secrets** → commit proceeds normally.
4. **New secrets found** → commit is blocked; `.secrets.baseline` is updated with new
   unaudited findings.
5. Developer reviews new entries in `.secrets.baseline`:
   - False positive: set `"is_secret": false` on the finding.
   - True secret: remove it from the staged files.
6. `git add .secrets.baseline` and re-commit — hook passes.

## Scope

- Applies only to `config` and `picnic-config` repos (per-repo `pre-commit install`).
- Does not affect any other repos on the machine.
- `.secrets.baseline` is committed in each repo individually.
