#!/usr/bin/env bash

set -euo pipefail

shellcheck --shell=bash --external-sources \
	bin/*

shfmt --language-dialect bash --diff \
	bin/*