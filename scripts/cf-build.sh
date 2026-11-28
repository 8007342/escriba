#!/usr/bin/env bash
# Build Escriba's Flutter web release for Cloudflare Workers Builds.
#
# Cloudflare's build image has no Flutter SDK, so this script downloads a
# pinned Flutter release into a cache directory (reused when the build cache
# keeps it), then runs `flutter build web --release` into build/web.
# Works locally too: if `flutter` of the pinned version is already on PATH it
# is used as-is.
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.7}"
FLUTTER_CHANNEL="stable"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_DIR="${FLUTTER_CACHE_DIR:-$ROOT/.cache/flutter-sdk}"
SDK_DIR="$CACHE_DIR/flutter-$FLUTTER_VERSION"

log() { printf '[cf-build] %s\n' "$*"; }

have_pinned_flutter() {
  command -v flutter >/dev/null 2>&1 &&
    flutter --version 2>/dev/null | head -n1 | grep -q "Flutter $FLUTTER_VERSION "
}

if have_pinned_flutter; then
  log "Using Flutter $FLUTTER_VERSION from PATH: $(command -v flutter)"
else
  if [ ! -x "$SDK_DIR/bin/flutter" ]; then
    archive="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
    url="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${archive}"
    log "Downloading Flutter $FLUTTER_VERSION ($url)"
    mkdir -p "$CACHE_DIR"
    tmp="$(mktemp -d "$CACHE_DIR/dl.XXXXXX")"
    trap 'rm -rf "$tmp"' EXIT
    curl -fSL --retry 3 --retry-delay 5 -o "$tmp/$archive" "$url"
    tar -xJf "$tmp/$archive" -C "$tmp"
    rm -rf "$SDK_DIR"
    mv "$tmp/flutter" "$SDK_DIR"
    rm -rf "$tmp"
    trap - EXIT
  else
    log "Using cached Flutter SDK at $SDK_DIR"
  fi
  export PATH="$SDK_DIR/bin:$PATH"
  # The SDK tarball is a git checkout owned by another uid in some CI images.
  git config --global --add safe.directory "$SDK_DIR" >/dev/null 2>&1 || true
fi

export FLUTTER_SUPPRESS_ANALYTICS=true
export CI=true
flutter config --no-analytics >/dev/null 2>&1 || true
flutter --version

cd "$ROOT"
flutter pub get
flutter build web --release

if [ ! -f build/web/index.html ]; then
  log "build/web/index.html is missing: build failed" >&2
  exit 1
fi
log "Built $(du -sh build/web | cut -f1) into build/web"
