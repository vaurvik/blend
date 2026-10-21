# Blend app icon assets

The Blend logo sources live in `assets/brand/`. `blend-icon-1024.png` is the canonical raster mark;
64, 256 and 512 px variants were supplied alongside it. `blend-logo.svg` wraps the canonical PNG
so the existing `packaging/icons.sh` pipeline can render platform-specific sizes with `resvg`.

The Desktop embeds the generated PNG icon on macOS and Linux, Windows embeds `blend.ico`, and
platform packaging consumes the generated `blend.icns` and Linux hicolor files. The filenames
still use Blend identifiers because the app and installers have not yet been renamed.

Regenerate platform icons with `packaging/icons.sh`. The four supplied source PNGs are retained
unchanged in `assets/brand/`.