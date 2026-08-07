#!/usr/bin/env bash
# Reinstall all GitHub-managed herdr plugins listed in plugins.json.
#
# Fresh machine: clone dotfiles, install herdr, run this once — every plugin
# installs itself from GitHub (network required).
# Already installed: re-running install replaces each checkout = bulk update.
set -euo pipefail

registry="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/plugins.json"
[ -f "$registry" ] || {
	echo "registry not found: $registry" >&2
	exit 1
}
command -v jq >/dev/null || {
	echo "jq required: brew install jq" >&2
	exit 1
}

mapfile -t specs < <(
	jq -r '.[] | select(.source.kind == "github")
         | [.source.owner, .source.repo, (.source.subdir // "")]
         | @tsv' "$registry" |
		while IFS=$'\t' read -r owner repo subdir; do
			printf '%s/%s%s\n' "$owner" "$repo" "${subdir:+/$subdir}"
		done
)

failed=0
for spec in "${specs[@]}"; do
	echo "==> herdr plugin install $spec"
	if ! herdr plugin install "$spec" --yes; then
		echo "    FAILED: $spec" >&2
		failed=1
	fi
done

exit "$failed"
