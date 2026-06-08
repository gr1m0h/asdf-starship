#!/usr/bin/env bash

set -euo pipefail

shellcheck --shell=bash --external-sources \
	bin/* \
	scripts/*

shfmt --language-dialect bash --diff \
	bin/* scripts/*
