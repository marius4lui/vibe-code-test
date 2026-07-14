#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT="${1:-../vibe-benchmark-expo/Bilder}"
OUTPUT_ROOT="${2:-docs/assets/screenshots}"
CROP_TOP=96
WIDTH=1080
HEIGHT=2296

command -v magick >/dev/null || {
  echo "ImageMagick (magick) is required." >&2
  exit 1
}

mkdir -p "$OUTPUT_ROOT"

process() {
  local stack="$1"
  local source_name="$2"
  local output_name="$3"
  local source="$SOURCE_ROOT/$stack/$source_name"
  local output="$OUTPUT_ROOT/$output_name"

  test -f "$source" || {
    echo "Missing source screenshot: $source" >&2
    exit 1
  }

  magick "$source" \
    -crop "${WIDTH}x${HEIGHT}+0+${CROP_TOP}" \
    +repage \
    -strip \
    -quality 88 \
    -define webp:method=6 \
    "$output"

  echo "$source_name -> $output_name"
}

process expo Screenshot_20260714-215253.png expo-onboarding-1.webp
process expo Screenshot_20260714-215259.png expo-onboarding-2.webp
process expo Screenshot_20260714-215303.png expo-onboarding-3.webp
process expo Screenshot_20260714-215307.png expo-dashboard.webp
process expo Screenshot_20260714-215311.png expo-categories.webp
process expo Screenshot_20260714-215315.png expo-tasks.webp
process expo Screenshot_20260714-215318.png expo-settings.webp
process expo Screenshot_20260714-215323.png expo-delete-dialog.webp

process flutter Screenshot_20260714-221325.png flutter-onboarding-1.webp
process flutter Screenshot_20260714-221327.png flutter-onboarding-2.webp
process flutter Screenshot_20260714-221329.png flutter-onboarding-3.webp
process flutter Screenshot_20260714-221332.png flutter-dashboard.webp
process flutter Screenshot_20260714-221335.png flutter-task-form.webp
process flutter Screenshot_20260714-221339.png flutter-tasks.webp
process flutter Screenshot_20260714-221344.png flutter-settings.webp
process flutter Screenshot_20260714-221349.png flutter-dashboard-detail.webp
process flutter Screenshot_20260714-221354.png flutter-today-tasks.webp

process kotlin Screenshot_20260714-215623.png kotlin-onboarding-1.webp
process kotlin Screenshot_20260714-215626.png kotlin-onboarding-2.webp
process kotlin Screenshot_20260714-215629.png kotlin-onboarding-3.webp
process kotlin Screenshot_20260714-215632.png kotlin-dashboard.webp
process kotlin Screenshot_20260714-215635.png kotlin-dashboard-tasks.webp
process kotlin Screenshot_20260714-215640.png kotlin-tasks.webp
process kotlin Screenshot_20260714-215645.png kotlin-settings-system.webp
process kotlin Screenshot_20260714-215650.png kotlin-settings-dark.webp
process kotlin Screenshot_20260714-215656.png kotlin-task-edit.webp
process kotlin Screenshot_20260714-215700.png kotlin-task-new.webp
