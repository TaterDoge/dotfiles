#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
rift-cli subscribe cli \
  --event windows_changed \
  --command "$SCRIPT_DIR/refocus-handler.sh" \
  2>/dev/null
