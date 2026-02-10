#!/usr/bin/env bash
set -e

THEME_DIR="$out/share/icons/RoseHeartCursor"
mkdir -p "$THEME_DIR/cursors"

# Write index.theme
cat > "$THEME_DIR/index.theme" << EOF
[Icon Theme]
Name=Rose Heart Cursor
Comment=Elegant thin rose gold cursor with heart accents
EOF

# Render SVGs to PNGs at multiple sizes
for svg in svgs/*.svg; do
  name=$(basename "$svg" .svg)
  for size in 24 32 48; do
    rsvg-convert -w $size -h $size "$svg" -o "/tmp/${name}_${size}.png"
  done

  # Create xcursorgen config
  # Format: size hotx hoty filename [delay]
  case "$name" in
    default)  hx=4;  hy=2;;
    pointer)  hx=10; hy=8;;
    text)     hx=16; hy=16;;
    wait)     hx=16; hy=16;;
    *)        hx=4;  hy=2;;
  esac

  cat > "/tmp/${name}.cursor" << EOF
24 $hx $hy /tmp/${name}_24.png
32 $((hx * 32 / 24)) $((hy * 32 / 24)) /tmp/${name}_32.png
48 $((hx * 2)) $((hy * 2)) /tmp/${name}_48.png
EOF

  xcursorgen "/tmp/${name}.cursor" "$THEME_DIR/cursors/$name"
done

# Create symlinks for cursor name aliases
cd "$THEME_DIR/cursors"

# default arrow aliases
for alias in left_ptr top_left_arrow arrow; do
  ln -sf default "$alias"
done

# pointer/hand aliases
for alias in hand hand1 hand2 pointing_hand; do
  ln -sf pointer "$alias"
done

# text aliases
for alias in xterm ibeam; do
  ln -sf text "$alias"
done

# wait aliases
for alias in watch left_ptr_watch progress half-busy; do
  ln -sf wait "$alias"
done
