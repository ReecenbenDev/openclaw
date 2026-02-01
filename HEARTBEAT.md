# Heartbeat checklist (24/7 digital workforce)

Customize this file on your deployment machine (e.g. MacStadium). The default heartbeat prompt tells the agent to read HEARTBEAT.md and follow it. Use cron for fixed-time cycles; use heartbeat for periodic check-ins.

## PRD-aligned schedule (reference)

| Cycle        | Window    | Focus              | Output / KPI                          |
| ------------ | --------- | ------------------ | ------------------------------------- |
| Hunter       | 08:00–10:00 | Vinitaco (leads)   | 10 pitches → Google Drive; DAC link /102543856 |
| Registrar    | 10:00–12:00 | Slide House       | BMI/ASCAP/MLC from ToRegister → Legal/Confirmations |
| Engineer     | 13:00–16:00 | Reecenben (Secure Share) | Notion "Ready for Dev" → code, Docker tests, PR |
| Creator      | 16:00–19:00 | Merch/Mediimedia   | TikTok trends → 15s Reel → Social_Queue |
| Accountant   | 19:00–20:00 | Empire report     | Gmail commissions → Master Revenue sheet → summary to phone |

## Heartbeat checklist (short)

- Quick scan: anything urgent in inboxes or Notion?
- If it's daytime, lightweight check-in if nothing else is pending.
- If a task is blocked, write down _what is missing_ and surface it next run.

Keep this file small to avoid prompt bloat. For time-bound cycles, use `openclaw cron add` with the appropriate schedule and system-event or message.
