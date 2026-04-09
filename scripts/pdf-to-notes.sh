#!/usr/bin/env bash
# pdf-to-notes.sh — Convert lecture PDFs to Markdown for study-ops
#
# Usage:
#   bash scripts/pdf-to-notes.sh <input> <output-dir>
#
#   <input>       Path to a single PDF file, or a directory of PDFs
#   <output-dir>  Where to write the .md files (e.g. notes/ds/)
#
# Examples:
#   bash scripts/pdf-to-notes.sh raw/ds/week1.pdf notes/ds/
#   bash scripts/pdf-to-notes.sh raw/ds/ notes/ds/
#
# Conversion priority (uses whichever is installed):
#   1. marker      — best quality, preserves structure, handles equations
#   2. pandoc      — good quality, widely available
#   3. pdftotext   — fastest, plaintext only (part of poppler-utils)
#
# Install options:
#   pip install marker-pdf
#   brew install pandoc  /  apt install pandoc
#   brew install poppler /  apt install poppler-utils

set -euo pipefail

INPUT="${1:-}"
OUTPUT_DIR="${2:-}"

# ── Validation ────────────────────────────────────────────────────────────────

if [[ -z "$INPUT" || -z "$OUTPUT_DIR" ]]; then
  echo "Usage: bash scripts/pdf-to-notes.sh <input-pdf-or-dir> <output-dir>"
  exit 1
fi

if [[ ! -e "$INPUT" ]]; then
  echo "Error: '$INPUT' not found."
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

# ── Detect converter ──────────────────────────────────────────────────────────

if command -v marker_single &>/dev/null; then
  CONVERTER="marker"
elif command -v pandoc &>/dev/null; then
  CONVERTER="pandoc"
elif command -v pdftotext &>/dev/null; then
  CONVERTER="pdftotext"
else
  echo "No converter found. Install one of:"
  echo "  pip install marker-pdf"
  echo "  brew install pandoc  (or apt install pandoc)"
  echo "  brew install poppler (or apt install poppler-utils)"
  exit 1
fi

echo "Using converter: $CONVERTER"
echo "Output dir: $OUTPUT_DIR"
echo ""

# ── Conversion function ───────────────────────────────────────────────────────

convert_pdf() {
  local pdf="$1"
  local out_dir="$2"
  local basename
  basename="$(basename "$pdf" .pdf)"
  local out_file="$out_dir/$basename.md"

  echo "Converting: $pdf → $out_file"

  case "$CONVERTER" in
    marker)
      marker_single "$pdf" --output_dir "$out_dir" --output_format markdown 2>/dev/null
      # marker names the output file differently — rename if needed
      local marker_out="$out_dir/$basename/$basename.md"
      if [[ -f "$marker_out" ]]; then
        mv "$marker_out" "$out_file"
        rmdir "$out_dir/$basename" 2>/dev/null || true
      fi
      ;;
    pandoc)
      pandoc "$pdf" -o "$out_file" --wrap=none 2>/dev/null
      ;;
    pdftotext)
      pdftotext -layout "$pdf" - 2>/dev/null \
        | sed 's/\f/\n---\n/g' \
        > "$out_file"
      ;;
  esac

  if [[ -f "$out_file" ]]; then
    # Inject a top-level heading if the file doesn't have one
    if ! grep -q "^# " "$out_file"; then
      local tmpfile
      tmpfile="$(mktemp)"
      echo "# $basename" > "$tmpfile"
      echo "" >> "$tmpfile"
      cat "$out_file" >> "$tmpfile"
      mv "$tmpfile" "$out_file"
    fi
    echo "  Done: $out_file"
  else
    echo "  Warning: output file not created for $pdf"
  fi
}

# ── Run ───────────────────────────────────────────────────────────────────────

if [[ -d "$INPUT" ]]; then
  shopt -s nullglob
  pdfs=("$INPUT"/*.pdf "$INPUT"/*.PDF)
  if [[ ${#pdfs[@]} -eq 0 ]]; then
    echo "No PDF files found in '$INPUT'."
    exit 1
  fi
  for pdf in "${pdfs[@]}"; do
    convert_pdf "$pdf" "$OUTPUT_DIR"
  done
else
  convert_pdf "$INPUT" "$OUTPUT_DIR"
fi

echo ""
echo "Conversion complete."
echo ""
echo "Next steps:"
echo "  1. Open each .md file in $OUTPUT_DIR"
echo "  2. Remove slide numbers, page footers, and repeated headers"
echo "  3. Fix any garbled equations (rewrite in plain text or LaTeX)"
echo "  4. Confirm each file starts with: # Week N — Topic Name"
echo "  5. Run: /study-ops review <course>"
