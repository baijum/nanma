#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

POSTER_TEX="$PROJECT_ROOT/assets/posters/countdown_poster.tex"
POSTER_DIR="$PROJECT_ROOT/assets/posters"
OUTPUT_DIR="$POSTER_DIR/generated"
TEMP_TEX="$OUTPUT_DIR/_render_wrapper.tex"

mkdir -p "$OUTPUT_DIR"

# Clean previous outputs so we don't mix days
rm -f "$OUTPUT_DIR"/countdown_*.{aux,log,pdf,png} 2>/dev/null || true

cleanup() {
  rm -f "$TEMP_TEX"
}
trap cleanup EXIT

for day in $(seq 47 -1 1); do
  jobname=$(printf "countdown_%02d" "$day")
  cat > "$TEMP_TEX" <<EOF
\def\PostersDaysOverride{$day}
\def\PosterGraphicPath{$POSTER_DIR/}
\input{$POSTER_TEX}
EOF

  echo "Rendering day $day (jobname: $jobname)"
  xelatex -interaction=nonstopmode -halt-on-error \
    -output-directory="$OUTPUT_DIR" \
    -jobname="$jobname" "$TEMP_TEX" >/dev/null

  # Second pass for stability (fonts/patterns)
  xelatex -interaction=nonstopmode -halt-on-error \
    -output-directory="$OUTPUT_DIR" \
    -jobname="$jobname" "$TEMP_TEX" >/dev/null

  magick -density 300 "$OUTPUT_DIR/$jobname.pdf[0]" -quality 100 "$OUTPUT_DIR/$jobname.png"
done

echo "Countdown PNG generation complete. Files are in $OUTPUT_DIR"


