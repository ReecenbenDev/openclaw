# PRD: 24/7 autonomous digital workforce

This doc maps the product requirements (PRD) to the Reecenbot/OpenClaw stack and ensures Telegram (and WhatsApp) are working for remote control and communication.

## 1. Mission

Deploy a 24/7 autonomous "digital workforce" managing a diversified portfolio (music, tech, financial services), targeting $1M+ enterprise value via automated lead gen, software development, and IP protection.

## 2. System architecture (PRD → stack)

| PRD component      | In this repo                          |
| ------------------- | ------------------------------------- |
| Orchestrator        | OpenClaw (Reecenbot whitelabel) as persistent macOS daemon |
| Intelligence        | Claude 3.5 Sonnet, Gemini 3 Pro, GPT-4o — configure in `models` / provider auth |
| Primary database    | Notion — use Notion skill + `agents` workspace; Leads/Tasks/Catalog as specified |
| Cloud storage       | Google Drive (e.g. `/Volumes/GoogleDrive`) — mount locally; paths in HEARTBEAT.md / cron |
| Communication       | **Telegram** + **WhatsApp** (remote control), Gmail (outreach) |

## 3. Telegram (remote control)

Telegram is production-ready. To get it working:

1. **Create a bot**: [@BotFather](https://t.me/BotFather) → `/newbot` → copy token.
2. **Set token** (one of):
   - Env: `TELEGRAM_BOT_TOKEN=123:abc...` in `.env`
   - Config: `~/.openclaw/openclaw.json` → `channels.telegram.botToken: "123:abc..."`
3. **Start gateway**: `openclaw gateway --port 18789` (or use your daemon).
4. **DM the bot**: Pairing is default; approve with `openclaw pairing approve telegram <CODE>`.

Minimal config snippet:

```json5
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "<from BotFather>",
      dmPolicy: "pairing",
    },
  },
}
```

Full options: [Telegram channel](/channels/telegram). For group remote control, add the bot to a group and set `channels.telegram.groups` / `groupPolicy` as needed.

## 4. WhatsApp

Use the built-in WhatsApp (Baileys) channel or Twilio. Configure in `channels.whatsapp` and set credentials (e.g. Twilio in `.env` if using Twilio). See [WhatsApp channel](/channels/whatsapp).

## 5. Business verticals (PRD → actions)

- **Vinitaco (financial)**: Lead gen → DAC link with `/102543856`; sync to e.g. `/Volumes/GoogleDrive/Vinitaco/Leads.csv`. Use cron/heartbeat + agent tools (browser, Gmail, drive paths).
- **Slide House (music)**: ISRC → BMI/ASCAP/MLC via browser-use; audit Spotify; keep "Finals" folder and Legal/Confirmations in Google Drive. Use cron for Registrar window.
- **Reecenben (software)**: Notion "Ready for Dev" → code + Docker tests + PR. Use cron for Engineer window; Nano Banana / assets as needed.
- **Mediimedia / Merchbygoods**: Trend scraping, Nano Banana mockups, Audiogram generation; output to `/Volumes/GoogleDrive/Media/Social_Queue`. Use cron for Creator window.
- **Accountant cycle**: Gmail → commissions/sales → Master Revenue sheet; summary to phone (e.g. via Telegram/WhatsApp).

## 6. Heartbeat and cron

- **HEARTBEAT.md**: Resides on the deployment machine; default heartbeat prompt tells the agent to read it. See repo-root [HEARTBEAT.md](/../../HEARTBEAT.md) for a PRD-aligned template.
- **Cron**: Use `openclaw cron add` for fixed windows (e.g. 08:00 Hunter, 10:00 Registrar). See [Cron jobs](/automation/cron-jobs) and [Heartbeat](/gateway/heartbeat).

## 7. Build and test

```bash
pnpm install
pnpm ui:build
pnpm build
pnpm test
```

Run gateway: `pnpm openclaw gateway --port 18789` (or `openclaw gateway` after install). Verify Telegram: set `TELEGRAM_BOT_TOKEN`, start gateway, DM the bot and approve pairing.
