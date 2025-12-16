#!/usr/bin/env bash
set -euo pipefail
# Ensure my bluetooth speaker is at unity gain

# What to match in `wpctl status` sink list
MATCH="${1:-JBL Charge}"
VOL="${2:-1.0}"

# Grab the first sink id whose line contains MATCH
SINK_ID="$(
  wpctl status \
  | awk -v m="$MATCH" '
      $0 ~ /^[[:space:]]*├─ Sinks:/ {insinks=1; next}
      insinks && $0 ~ /^[[:space:]]*├─ Sources:/ {exit}
      insinks && $0 ~ m {
        # lines look like: " │  *  152. JBL Charge [vol: 0.40]"
        for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+\.$/) {gsub(/\./,"",$i); print $i; exit}
      }'
)"

if [[ -z "${SINK_ID}" ]]; then
  echo "ERROR: Could not find a sink matching: ${MATCH}" >&2
  echo "Run: wpctl status" >&2
  exit 1
fi

wpctl set-volume "$SINK_ID" "$VOL"
wpctl set-default "$SINK_ID" >/dev/null 2>&1 || true

echo "Set sink ${SINK_ID} (${MATCH}) volume to ${VOL}"
wpctl get-volume "$SINK_ID"

