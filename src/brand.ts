/**
 * Whitelabel: display name shown to users (README, docs, UI).
 * Internal package/CLI/config stay "openclaw".
 */
export const BRAND_DISPLAY_NAME =
  (typeof process !== "undefined" && process.env?.REECENBOT_BRAND_NAME?.trim()) || "Reecenbot";
