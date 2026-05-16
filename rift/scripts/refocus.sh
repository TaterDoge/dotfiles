#!/bin/bash
# When a floating window is closed, focus can get stuck on the dead app.
# This script tries to move focus to a tiled window if no tiled window is focused.

# Wait for rift to update its internal state
sleep 0

# Query current workspace windows
WINDOWS=$(rift-cli query windows 2>/dev/null)

# If no windows at all, nothing to do
if [ -z "$WINDOWS" ] || [ "$RIFT_WINDOW_COUNT" = "0" ]; then
  exit 0
fi

# Check if any tiled window is focused; if not, move focus
HAS_TILED_FOCUS=$(echo "$WINDOWS" | python3 -c "
import sys, json
wins = json.load(sys.stdin)
for w in wins:
    if not w.get('is_floating', False) and w.get('is_focused', False):
        print('yes')
        sys.exit(0)
print('no')
" 2>/dev/null)

if [ "$HAS_TILED_FOCUS" = "no" ]; then
  # No tiled window has focus; try to move focus to a tiled one
  # Use directional focus as fallback
  rift-cli execute window focus left 2>/dev/null ||
    rift-cli execute window focus right 2>/dev/null ||
    rift-cli execute window focus up 2>/dev/null ||
    rift-cli execute window next 2>/dev/null
fi
