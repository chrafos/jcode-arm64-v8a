# One-Click Local Android Cross-Compiler & Updater for Jcode
$ErrorActionPreference = "Stop"

Write-Host "==> Checking Git remote & pulling latest..." -ForegroundColor Cyan
if (Test-Path ".git") {
    git pull --rebase
} else {
    Write-Host "Not a git repo, skipping pull." -ForegroundColor Yellow
}

$ndkPath = "C:\Users\mocri\Downloads\App\android-ndk-r27"
if (-not (Test-Path $ndkPath)) {
    Write-Host "Android NDK not found at $ndkPath!" -ForegroundColor Red
    exit 1
}

$llvmBin = "C:\Program Files\LLVM\bin"
$env:PATH = "$llvmBin;$ndkPath\toolchains\llvm\prebuilt\windows-x86_64\bin;" + $env:PATH
$env:LIBCLANG_PATH = $llvmBin
$env:ANDROID_NDK_HOME = $ndkPath

Write-Host "==> Building Jcode for Android arm64-v8a..." -ForegroundColor Cyan
cargo build --release --target aarch64-linux-android --bin jcode

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

$srcBin = "target\aarch64-linux-android\release\jcode"
$distDir = "dist"
$distBin = "$distDir\jcode-arm64-v8a"

if (-not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Force -Path $distDir | Out-Null
}

Write-Host "==> Stripping debug symbols..." -ForegroundColor Cyan
$stripper = "$ndkPath\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-strip.exe"
& $stripper --strip-all $srcBin

Copy-Item $srcBin $distBin -Force
$sizeMb = [math]::Round((Get-Item $distBin).Length / 1MB, 2)

Write-Host "`nSUCCESS! Built stripped Android binary: $distBin ($sizeMb MB)" -ForegroundColor Green
Write-Host "To copy to Termux:" -ForegroundColor White
Write-Host "  adb push $distBin /data/local/tmp/jcode" -ForegroundColor Gray
Write-Host "  OR copy $distBin to your phone's Download folder." -ForegroundColor Gray
