#!/usr/bin/env bash

set -euo pipefail

# Run shellcheck on all bin scripts
echo "Running shellcheck..."
shellcheck --shell=bash --external-sources bin/*

# Run shfmt check on all bin scripts  
echo "Running shfmt..."
shfmt --language-dialect bash --diff bin/*

echo "Linting completed successfully!"