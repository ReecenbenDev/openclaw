---
summary: "Reset and set up the app from scratch when things are broken"
read_when:
  - Gateway or app won't start
  - You want a clean slate and re-run onboarding
title: "Reset and setup"
---

# Reset and setup

Use this when the app or gateway is not working and you want to reset and set up from scratch.

## Option A: Script (recommended)

From the repo root (where `package.json` and `scripts/` live):

```bash
./scripts/reset-and-setup.sh
```

This will:

1. Stop the Gateway service (launchd/systemd).
2. Kill any running Reecenbot app and gateway processes.
3. **Keep** your config and state (`~/.openclaw`).
4. Run `pnpm install`, `pnpm ui:build`, `pnpm build`.
5. Reinstall the Gateway daemon and start it.

After that, the gateway should be running. Open the dashboard: `openclaw dashboard` or http://127.0.0.1:18789.

### Full reset (wipe config and re-onboard)

To remove all config and state and run onboarding again from zero:

```bash
./scripts/reset-and-setup.sh --clean-config
```

Then:

1. (Optional) Export env from `.env`: `set -a && source .env && set +a`
2. Run onboarding: `openclaw onboard --install-daemon` (or `pnpm openclaw onboard --install-daemon` from source).
3. For Telegram: set `TELEGRAM_BOT_TOKEN` in `.env` or in config. **If the gateway runs as a daemon**, put the token in config (`channels.telegram.botToken` in `~/.openclaw/openclaw.json`) so the daemon sees it; the daemon does not load `.env`. Then DM the bot and run: `openclaw pairing approve telegram <CODE>`.

## Option B: Manual steps

If the script fails (e.g. `pnpm` not in PATH), do the same steps by hand:

1. **Stop the gateway**

   ```bash
   openclaw gateway stop
   ```

   (Or `openclaw daemon stop`.)

2. **Kill any stuck processes**

   - Quit the Reecenbot/OpenClaw menubar app from the menu bar (or Activity Monitor).
   - If needed: `pkill -f openclaw` or `pkill -f Reecenbot`.

3. **Optional: full reset**

   To start completely fresh:

   ```bash
   rm -rf ~/.openclaw
   ```

   Then skip to step 6 and run onboarding.

4. **Reinstall and build (from repo root)**

   ```bash
   pnpm install
   pnpm ui:build
   pnpm build
   ```

5. **Reinstall and start the gateway** (if you kept config)

   ```bash
   openclaw gateway install --force --runtime node
   openclaw gateway start
   ```

6. **If you wiped config: run onboarding**

   ```bash
   openclaw onboard --install-daemon
   ```

## Env and config notes

- The CLI does **not** load `.env` from the project root automatically. To use `.env` (e.g. `TELEGRAM_BOT_TOKEN`, `ANTHROPIC_API_KEY`), either:
  - Export before running: `set -a && source .env && set +a`, then run `openclaw`; or
  - Put the same values into config via `openclaw config set` or the onboarding wizard.
- If you use a path like `STORAGE_ROOT` in `.env`, make sure it exists on this machine (e.g. on a Mac mini use `/Users/administrator/...` if you are user `administrator`).

## Verify

After reset and setup:

- Gateway: `openclaw gateway probe`
- Channels: `openclaw channels status --probe`
- Dashboard: `openclaw dashboard` or open http://127.0.0.1:18789

See [Chat not working](/help/troubleshooting#chat-not-working) if Telegram or other channels still fail.
