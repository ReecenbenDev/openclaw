---
summary: "CLI reference for `reecenbot agents` (list/add/delete/set identity)"
read_when:
  - You want multiple isolated agents (workspaces + routing + auth)
title: "agents"
---

# `reecenbot agents`

Manage isolated agents (workspaces + auth + routing).

Related:

- Multi-agent routing: [Multi-Agent Routing](/concepts/multi-agent)
- Agent workspace: [Agent workspace](/concepts/agent-workspace)

## Examples

```bash
reecenbot agents list
reecenbot agents add work --workspace ~/.reecenbot/workspace-work
reecenbot agents set-identity --workspace ~/.reecenbot/workspace --from-identity
reecenbot agents set-identity --agent main --avatar avatars/reecenbot.png
reecenbot agents delete work
```

## Identity files

Each agent workspace can include an `IDENTITY.md` at the workspace root:

- Example path: `~/.reecenbot/workspace/IDENTITY.md`
- `set-identity --from-identity` reads from the workspace root (or an explicit `--identity-file`)

Avatar paths resolve relative to the workspace root.

## Set identity

`set-identity` writes fields into `agents.list[].identity`:

- `name`
- `theme`
- `emoji`
- `avatar` (workspace-relative path, http(s) URL, or data URI)

Load from `IDENTITY.md`:

```bash
reecenbot agents set-identity --workspace ~/.reecenbot/workspace --from-identity
```

Override fields explicitly:

```bash
reecenbot agents set-identity --agent main --name "Reecenbot" --emoji "🦞" --avatar avatars/reecenbot.png
```

Config sample:

```json5
{
  agents: {
    list: [
      {
        id: "main",
        identity: {
          name: "Reecenbot",
          theme: "space lobster",
          emoji: "🦞",
          avatar: "avatars/reecenbot.png",
        },
      },
    ],
  },
}
```
