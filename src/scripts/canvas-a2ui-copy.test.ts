import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { describe, expect, it } from "vitest";
import { copyA2uiAssets } from "../../scripts/canvas-a2ui-copy.js";

describe("canvas a2ui copy", () => {
  it("throws when assets are missing and OPENCLAW_A2UI_REQUIRE_BUNDLE=1", async () => {
    const dir = await fs.mkdtemp(path.join(os.tmpdir(), "reecenbot-a2ui-"));
    const prev = process.env.OPENCLAW_A2UI_REQUIRE_BUNDLE;
    process.env.OPENCLAW_A2UI_REQUIRE_BUNDLE = "1";
    try {
      await expect(copyA2uiAssets({ srcDir: dir, outDir: path.join(dir, "out") })).rejects.toThrow(
        'Run "pnpm canvas:a2ui:bundle"',
      );
    } finally {
      if (prev !== undefined) process.env.OPENCLAW_A2UI_REQUIRE_BUNDLE = prev;
      else delete process.env.OPENCLAW_A2UI_REQUIRE_BUNDLE;
      await fs.rm(dir, { recursive: true, force: true });
    }
  });

  it("skips with warning when assets are missing and REQUIRE_BUNDLE is not set", async () => {
    const dir = await fs.mkdtemp(path.join(os.tmpdir(), "reecenbot-a2ui-"));
    try {
      await expect(
        copyA2uiAssets({ srcDir: dir, outDir: path.join(dir, "out") }),
      ).resolves.toBeUndefined();
    } finally {
      await fs.rm(dir, { recursive: true, force: true });
    }
  });

  it("copies bundled assets to dist", async () => {
    const dir = await fs.mkdtemp(path.join(os.tmpdir(), "reecenbot-a2ui-"));
    const srcDir = path.join(dir, "src");
    const outDir = path.join(dir, "dist");

    try {
      await fs.mkdir(srcDir, { recursive: true });
      await fs.writeFile(path.join(srcDir, "index.html"), "<html></html>", "utf8");
      await fs.writeFile(path.join(srcDir, "a2ui.bundle.js"), "console.log(1);", "utf8");

      await copyA2uiAssets({ srcDir, outDir });

      await expect(fs.stat(path.join(outDir, "index.html"))).resolves.toBeTruthy();
      await expect(fs.stat(path.join(outDir, "a2ui.bundle.js"))).resolves.toBeTruthy();
    } finally {
      await fs.rm(dir, { recursive: true, force: true });
    }
  });
});
