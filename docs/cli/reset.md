---
summary: "CLI reference for `reecenbot reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `reecenbot reset`

Reset local config/state (keeps the CLI installed).

```bash
reecenbot reset
reecenbot reset --dry-run
reecenbot reset --scope config+creds+sessions --yes --non-interactive
```
