# Session State: Android arm64 Build

- **Date**: 2026-11-19
- **Target**: `aarch64-linux-android` (arm64-v8a) for Termux
- **Workflow**: `.github/workflows/android-release.yml`
- **Latest Successful Run**: Run 12 (`44483022870`)
- **Artifact**: `jcode-arm64-v8a` (zip artifact size: 37.36 MB, decompressed ~80 MB)
- **Status**: Completed & Verified

## Problem & Solution Log:

1. **GitHub MCP Authentication**:
   - Token configured in `C:\Users\mocri\.jcode\mcp.json` under `github` server env (`GITHUB_PERSONAL_ACCESS_TOKEN`).
   - GitHub MCP tools operational.

2. **Upstream Sync Overwrite Loop**:
   - Step 3 was running `git merge upstream/master -X ours` on every push, overwriting patches.
   - Added `if: github.event_name == 'schedule' || github.event_name == 'workflow_dispatch'` to prevent push overwrites (`9e09a0c`).

3. **Toolchain Path Resolution**:
   - Fixed linker and env variables in workflow to point to detected NDK toolchain (`$TOOLCHAIN/bin/aarch64-linux-android24-clang`).

4. **Ratatui Dependency Version Conflicts in Vendored Crates**:
   - `vendor/ratatui-jcode/ratatui-core/Cargo.toml`: Bumped to `0.1.2` (`8fab949`).
   - `vendor/ratatui-jcode/ratatui-widgets/Cargo.toml`: Bumped to `0.3.2` (`3b3362b`).

5. **Binary Size Optimization (113 MB -> 37 MB zipped / ~80 MB binary)**:
   - Upstream default profile used `codegen-units = 256` and `opt-level = 1`.
   - Updated `Cargo.toml` `[profile.release-lto]` with `opt-level = 3`, `codegen-units = 1`, `lto = "thin"`, `panic = "abort"`, and `strip = true`.
   - Updated `.github/workflows/android-release.yml` to build with `--profile release-lto` (`e080ca4`).
   - Run 12 completed successfully in 7m 25s, outputting 37.3 MB zipped artifact.
