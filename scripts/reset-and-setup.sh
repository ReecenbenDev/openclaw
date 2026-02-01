#!/usr/bin/env bash
# Reset and set up the app from scratch: stop gateway, optionally wipe config, reinstall deps, build, reinstall daemon.
# Use --clean-config to remove ~/.openclaw and run onboarding again from zero.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${OPENCLAW_STATE_DIR:-${HOME}/.openclaw}"
APP_PROCESS_PATTERN="Reecenbot.app/Contents/MacOS/Reecenbot"
DEBUG_PROCESS_PATTERN="${ROOT_DIR}/apps/macos/.build/debug/Reecenbot"
GATEWAY_PATTERN="openclaw.*gateway|gateway.*openclaw"
CLEAN_CONFIG=0

log() { printf '%s\n' "$*"; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# Ensure local node/pnpm are on PATH when running from repo.
export PATH="${ROOT_DIR}/node_modules/.bin:${PATH}"

# Resolve CLI: from source use pnpm openclaw, else openclaw.
resolve_cli() {
  if command -v pnpm >/dev/null 2>&1 && [[ -f "${ROOT_DIR}/package.json" ]] && grep -q '"openclaw"' "${ROOT_DIR}/package.json" 2>/dev/null; then
    echo "pnpm openclaw"
  else
    echo "openclaw"
  fi
}

for arg in "$@"; do
  case "${arg}" in
    --clean-config) CLEAN_CONFIG=1 ;;
    -h|--help)
      log "Usage: $(basename "$0") [--clean-config]"
      log "  --clean-config  Remove ~/.openclaw and run onboarding from zero (default: keep config, reinstall daemon only)"
      exit 0
      ;;
    *) ;;
  esac
done

CLI="$(resolve_cli)"
log "==> Using CLI: ${CLI}"

# 1) Stop Gateway service (launchd/systemd)
log "==> Stopping Gateway service"
if $CLI gateway stop 2>/dev/null; then
  log "    Gateway service stopped"
else
  log "    Gateway not running or stop failed (continuing)"
fi

# 2) Kill any running Reecenbot app and gateway processes
log "==> Killing Reecenbot and gateway processes"
for _ in 1 2 3; do
  pkill -f "${APP_PROCESS_PATTERN}" 2>/dev/null || true
  pkill -f "${DEBUG_PROCESS_PATTERN}" 2>/dev/null || true
  pkill -x "Reecenbot" 2>/dev/null || true
  pkill -f "openclaw.*gateway" 2>/dev/null || true
  pkill -f "node.*gateway" 2>/dev/null || true
  sleep 0.3
done

# 3) Optionally remove config (full reset)
if [[ "$CLEAN_CONFIG" -eq 1 ]]; then
  if [[ -d "$STATE_DIR" ]]; then
    log "==> Removing state directory (full reset): ${STATE_DIR}"
    rm -rf "${STATE_DIR}"
  fi
else
  log "==> Keeping config and state (${STATE_DIR})"
fi

# 4) Reinstall dependencies and build
log "==> Installing dependencies (pnpm install)"
cd "${ROOT_DIR}"
pnpm install || fail "pnpm install failed"

log "==> Building UI (pnpm ui:build)"
pnpm ui:build || fail "pnpm ui:build failed"

log "==> Building project (pnpm build)"
pnpm build || fail "pnpm build failed"

# 5) Reinstall daemon and start (unless full reset)
if [[ "$CLEAN_CONFIG" -eq 1 ]]; then
  log ""
  log "==> Full reset done. Next steps:"
  log "    1. Export env from .env (optional): set -a && source .env && set +a"
  log "    2. Run onboarding: ${CLI} onboard --install-daemon"
  log "    3. Start gateway (if not auto-started): ${CLI} gateway start"
  log "    4. For Telegram: set TELEGRAM_BOT_TOKEN in .env or config, then DM the bot and run: ${CLI} pairing approve telegram <CODE>"
  exit 0
fi

log "==> Reinstalling Gateway daemon (--force)"
$CLI gateway install --force --runtime node || fail "Gateway install failed"

log "==> Starting Gateway"
$CLI gateway start || fail "Gateway start failed"

log ""
log "==> Reset and setup complete. Gateway is running."
log "    Dashboard: ${CLI} dashboard   or open http://127.0.0.1:18789"
log "    Status:    ${CLI} channels status --probe"
