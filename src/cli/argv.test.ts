import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it("detects help/version flags", () => {
    expect(hasHelpOrVersion(["node", "reecenbot", "--help"])).toBe(true);
    expect(hasHelpOrVersion(["node", "reecenbot", "-V"])).toBe(true);
    expect(hasHelpOrVersion(["node", "reecenbot", "status"])).toBe(false);
  });

  it("extracts command path ignoring flags and terminator", () => {
    expect(getCommandPath(["node", "reecenbot", "status", "--json"], 2)).toEqual(["status"]);
    expect(getCommandPath(["node", "reecenbot", "agents", "list"], 2)).toEqual(["agents", "list"]);
    expect(getCommandPath(["node", "reecenbot", "status", "--", "ignored"], 2)).toEqual(["status"]);
  });

  it("returns primary command", () => {
    expect(getPrimaryCommand(["node", "reecenbot", "agents", "list"])).toBe("agents");
    expect(getPrimaryCommand(["node", "reecenbot"])).toBeNull();
  });

  it("parses boolean flags and ignores terminator", () => {
    expect(hasFlag(["node", "reecenbot", "status", "--json"], "--json")).toBe(true);
    expect(hasFlag(["node", "reecenbot", "--", "--json"], "--json")).toBe(false);
  });

  it("extracts flag values with equals and missing values", () => {
    expect(getFlagValue(["node", "reecenbot", "status", "--timeout", "5000"], "--timeout")).toBe(
      "5000",
    );
    expect(getFlagValue(["node", "reecenbot", "status", "--timeout=2500"], "--timeout")).toBe(
      "2500",
    );
    expect(getFlagValue(["node", "reecenbot", "status", "--timeout"], "--timeout")).toBeNull();
    expect(getFlagValue(["node", "reecenbot", "status", "--timeout", "--json"], "--timeout")).toBe(
      null,
    );
    expect(getFlagValue(["node", "reecenbot", "--", "--timeout=99"], "--timeout")).toBeUndefined();
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "reecenbot", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "reecenbot", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "reecenbot", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it("parses positive integer flag values", () => {
    expect(getPositiveIntFlagValue(["node", "reecenbot", "status"], "--timeout")).toBeUndefined();
    expect(
      getPositiveIntFlagValue(["node", "reecenbot", "status", "--timeout"], "--timeout"),
    ).toBeNull();
    expect(
      getPositiveIntFlagValue(["node", "reecenbot", "status", "--timeout", "5000"], "--timeout"),
    ).toBe(5000);
    expect(
      getPositiveIntFlagValue(["node", "reecenbot", "status", "--timeout", "nope"], "--timeout"),
    ).toBeUndefined();
  });

  it("builds parse argv from raw args", () => {
    const nodeArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["node", "reecenbot", "status"],
    });
    expect(nodeArgv).toEqual(["node", "reecenbot", "status"]);

    const versionedNodeArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["node-22", "reecenbot", "status"],
    });
    expect(versionedNodeArgv).toEqual(["node-22", "reecenbot", "status"]);

    const versionedNodeWindowsArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["node-22.2.0.exe", "reecenbot", "status"],
    });
    expect(versionedNodeWindowsArgv).toEqual(["node-22.2.0.exe", "reecenbot", "status"]);

    const versionedNodePatchlessArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["node-22.2", "reecenbot", "status"],
    });
    expect(versionedNodePatchlessArgv).toEqual(["node-22.2", "reecenbot", "status"]);

    const versionedNodeWindowsPatchlessArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["node-22.2.exe", "reecenbot", "status"],
    });
    expect(versionedNodeWindowsPatchlessArgv).toEqual(["node-22.2.exe", "reecenbot", "status"]);

    const versionedNodeWithPathArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["/usr/bin/node-22.2.0", "reecenbot", "status"],
    });
    expect(versionedNodeWithPathArgv).toEqual(["/usr/bin/node-22.2.0", "reecenbot", "status"]);

    const nodejsArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["nodejs", "reecenbot", "status"],
    });
    expect(nodejsArgv).toEqual(["nodejs", "reecenbot", "status"]);

    const nonVersionedNodeArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["node-dev", "reecenbot", "status"],
    });
    expect(nonVersionedNodeArgv).toEqual(["node", "reecenbot", "node-dev", "reecenbot", "status"]);

    const directArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["reecenbot", "status"],
    });
    expect(directArgv).toEqual(["node", "reecenbot", "status"]);

    const bunArgv = buildParseArgv({
      programName: "reecenbot",
      rawArgs: ["bun", "src/entry.ts", "status"],
    });
    expect(bunArgv).toEqual(["bun", "src/entry.ts", "status"]);
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "reecenbot",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "reecenbot", "status"]);
  });

  it("decides when to migrate state", () => {
    expect(shouldMigrateState(["node", "reecenbot", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "reecenbot", "health"])).toBe(false);
    expect(shouldMigrateState(["node", "reecenbot", "sessions"])).toBe(false);
    expect(shouldMigrateState(["node", "reecenbot", "memory", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "reecenbot", "agent", "--message", "hi"])).toBe(false);
    expect(shouldMigrateState(["node", "reecenbot", "agents", "list"])).toBe(true);
    expect(shouldMigrateState(["node", "reecenbot", "message", "send"])).toBe(true);
  });

  it("reuses command path for migrate state decisions", () => {
    expect(shouldMigrateStateFromPath(["status"])).toBe(false);
    expect(shouldMigrateStateFromPath(["agents", "list"])).toBe(true);
  });
});
