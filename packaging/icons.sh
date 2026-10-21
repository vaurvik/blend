#!/usr/bin/env bash
# Regenerate every derived app icon from the Blend mark in assets/brand/blend-icon-1024.png.
#
# Needs: resvg (brew install resvg / cargo install resvg). On macOS, iconutil also writes the
# .icns. The outputs are committed, so builds and packaging never need these tools.
#
#   packaging/icons.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="$ROOT/assets/app-icon"
SVG="$ROOT/assets/brand/blend-logo.svg"
APP_ID="ai.storyteller.blend"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v resvg >/dev/null || { echo "error: resvg not found (brew install resvg)" >&2; exit 1; }

render() { resvg -w "$2" -h "$2" "$1" "$3" </dev/null; }

render "$SVG" 1024 "$DIR/blend-1024.png"
# Runtime window/Dock icon on macOS (apps/blend/src/main.rs embeds it).
render "$SVG" 512 "$DIR/blend-macos-512.png"

# Linux hicolor theme. Windows and Linux use the full-bleed tile.
for s in 16 24 32 48 64 128 256 512; do
  mkdir -p "$DIR/hicolor/${s}x${s}/apps"
  render "$SVG" "$s" "$DIR/hicolor/${s}x${s}/apps/$APP_ID.png"
done
mkdir -p "$DIR/hicolor/scalable/apps"
sed 's|href="blend-icon-1024.png"|href="../../../../brand/blend-icon-1024.png"|' "$SVG" >"$DIR/hicolor/scalable/apps/$APP_ID.svg"


# Windows .ico.
ICO_PNGS=()
for s in 16 20 24 32 40 48 64 128 256; do
  render "$SVG" "$s" "$TMP/ico-$s.png"
  ICO_PNGS+=("$TMP/ico-$s.png")
done
(cd "$ROOT" && cargo run -q -p xtask -- ico "$DIR/blend.ico" "${ICO_PNGS[@]}")

# macOS .icns.
if command -v iconutil >/dev/null; then
  SET="$TMP/blend.iconset"
  mkdir -p "$SET"
  for s in 16 32 128 256 512; do
    render "$SVG" "$s" "$SET/icon_${s}x${s}.png"
    render "$SVG" $((s * 2)) "$SET/icon_${s}x${s}@2x.png"
  done
  iconutil -c icns -o "$DIR/blend.icns" "$SET"
else
  echo "warning: iconutil not found (macOS only); blend.icns not regenerated" >&2
fi
echo "icons written to $DIR"
