#!/bin/bash
sleep 0.2
HAS_TILED_FOCUS=$(rift-cli query windows 2>/dev/null | \
  jq -e '[.[] | select(.is_floating == false and .is_focused == true)] | length > 0' 2>/dev/null)

if [ "$HAS_TILED_FOCUS" = "false" ]; then
  rift-cli execute window focus left 2>/dev/null || \
    rift-cli execute window focus right 2>/dev/null || \
    rift-cli execute window next 2>/dev/null
fi
