# Session State: Android arm64 Build

- **Date**: 2026-11-19
- **Target**: `aarch64-linux-android` (arm64-v8a) for Termux
- **Binary path**: `dist/jcode-arm64-v8a`
- **Binary size**: 91.33 MB (stripped)

## One-Click Automation Added:
- **Local (Windows)**: Double-click `build-android.bat` or run `./build-android.ps1`
  - Pulls updates
  - Runs cross-compiler with Android NDK and LLVM
  - Strips debug symbols
  - Outputs directly to `dist/jcode-arm64-v8a`
- **Cloud (GitHub Actions)**: `.github/workflows/android-release.yml`
  - Automatically compiles and produces stripped `jcode-arm64-v8a` release artifact on GitHub.

1. **Toolchain**:
   - Android NDK r27 installed in `C:\Users\mocri\Downloads\App\android-ndk-r27`.
   - LLVM / Clang installed in `C:\Program Files\LLVM`.
   - Cargo configured in `.cargo/config.toml` targeting `aarch64-linux-android24-clang.cmd`.
2. **OpenSSL / IMAP**:
   - Switched `jcode-notify-email`'s IMAP dependency to `rustls-tls` to avoid uncompiled `openssl-sys` C runtime errors.
3. **QuickJS / Codemode**:
   - Disabled `rquickjs-sys` on `target_os = "android"` in `crates/jcode-codemode` (unavailable bindings bypassed cleanly).
4. **Clipboard / arboard**:
   - Added `vendor/arboard` patched with an Android dummy fallback module implementing `get_text`, `set_text`, `file_list`, etc., without X11 or Wayland dependencies.
   - Added patch override into root `Cargo.toml`.
