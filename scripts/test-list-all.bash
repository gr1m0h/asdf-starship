#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cat >"$work/git" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
[ "$*" = "ls-remote --tags --refs https://github.com/starship/starship.git" ]
case "${TEST_MODE:-versions}" in
fail) exit 128 ;;
empty) exit 0 ;;
esac
printf 'sha\trefs/tags/%s\n' v1.10.0 v1.2.0 v2.0.0-rc.1 v0.9.0 other v1.2.0
MOCK
chmod +x "$work/git"
export PATH="$work:$PATH"
actual=$(bash "$repo/bin/list-all")
[ "$actual" = "0.9.0 1.2.0 1.10.0" ] || {
	echo "Unexpected versions: $actual" >&2
	exit 1
}
for TEST_MODE in fail empty; do
	export TEST_MODE
	if bash "$repo/bin/list-all" >"$work/output" 2>"$work/error"; then
		echo "Accepted $TEST_MODE version discovery" >&2
		exit 1
	fi
	[ ! -s "$work/output" ]
done
echo "${repo##*/}: version discovery checks passed"
