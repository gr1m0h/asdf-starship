#!/usr/bin/env bash

set -euo pipefail

shfmt --language-dialect bash --write \
	bin/* scripts/*
