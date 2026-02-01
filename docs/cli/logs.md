---
summary: "CLI reference for `reecenbot logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `reecenbot logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
reecenbot logs
reecenbot logs --follow
reecenbot logs --json
reecenbot logs --limit 500
```
