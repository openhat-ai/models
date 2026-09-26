#!/usr/bin/env bash
set -exuo pipefail

input="${1:-https://models.dev/catalog.json}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resolve_raw() {
  [[ -f "$1" ]] && {
    echo "$1"
    return
  }
  curl -fsSL "$1" -o _raw.json
  echo _raw.json
}

raw="$(resolve_raw "$input")"

jq -c '
  .providers as $providers |
  {
    providers: [
      $providers[] |
      del(.models)
    ],
    models: [
      $providers[] as $p |
      $p.models[] |
      if (.provider | type) == "object"
      then .override = .provider
      else .
      end |
      .provider = $p.id
    ]
  }
' "$raw" >_flat.json

jq -c '.models[]' _flat.json |
  python3 "$script_dir/sort.py" >_full.jsonl

jq -c --slurpfile models _full.jsonl \
  '.models = $models' \
  _flat.json >catalog.full.json

tq '[knowledge > 2025-00; last_updated > 2026-00]' \
  _full.jsonl >_recent.jsonl

jq -c --slurpfile models _recent.jsonl \
  '.models = $models' \
  _flat.json >catalog.json
