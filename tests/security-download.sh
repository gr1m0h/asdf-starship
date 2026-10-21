#!/usr/bin/env bash
set -euo pipefail
repo=${1:-$(cd "$(dirname "$0")/.." && pwd)}
repo=$(cd "$repo" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin" "$work/download"
printf 'payload\n' >"$work/payload"
export TEST_HASH
TEST_HASH=$(shasum -a 256 "$work/payload" | cut -d ' ' -f 1)
cat >"$work/bin/uname" <<'MOCK'
#!/usr/bin/env bash
case "$1" in -s) echo Darwin ;; -m) echo arm64 ;; *) exit 1 ;; esac
MOCK
cat >"$work/bin/curl" <<'MOCK'
#!/usr/bin/env bash
set -eu
[ "${TEST_MODE:-}" != fail ] || exit 22
out= url=
while [ "$#" -gt 0 ]; do
  case "$1" in -o) out=$2; shift 2 ;; https://*) url=$1; shift ;; *) shift ;; esac
done
[ -n "$out" ] && [ -n "$url" ]
case "$url" in
  *checksums.txt|*.sha256)
    [ "${TEST_MODE:-}" != missing ] || { echo 'unrelated' > "$out"; exit 0; }
    hash=$TEST_HASH
    [ "${TEST_MODE:-}" != mismatch ] || hash=0000000000000000000000000000000000000000000000000000000000000000
    for name in act_Darwin_arm64.tar.gz k6-v1.2.3-macos-arm64.zip starship-aarch64-apple-darwin.tar.gz vegeta-1.2.3-darwin-arm64.tar.gz vegeta_1.2.3_darwin_arm64.tar.gz; do printf '%s  %s\n' "$hash" "$name"; done > "$out"
    ;;
  *) printf 'payload\n' > "$out" ;;
esac
MOCK
chmod +x "$work/bin/"*
export PATH="$work/bin:$PATH" ASDF_INSTALL_VERSION=1.2.3 ASDF_DOWNLOAD_PATH="$work/download"
bash "$repo/bin/download"
for TEST_MODE in fail; do
	export TEST_MODE
	if bash "$repo/bin/download" >/dev/null 2>&1; then
		echo "accepted $TEST_MODE" >&2
		exit 1
	fi
done
case "${repo##*/}" in
asdf-act | asdf-k6 | asdf-starship | asdf-vegeta)
	for TEST_MODE in missing mismatch; do
		export TEST_MODE
		if bash "$repo/bin/download" >/dev/null 2>&1; then
			echo "accepted $TEST_MODE" >&2
			exit 1
		fi
	done
	;;
esac
unset TEST_MODE
ASDF_INSTALL_VERSION='../evil'
export ASDF_INSTALL_VERSION
if bash "$repo/bin/download" >/dev/null 2>&1; then
	echo 'accepted invalid version' >&2
	exit 1
fi
echo "${repo##*/}: security download checks passed"
