#!/bin/sh
set -eu

minimal_init=$(dirname "${0}")/../tests/minimal.lua

nvim \
    --headless \
    --noplugin \
    -u "${minimal_init}" \
    -c "PlenaryBustedDirectory tests/ { minimal_init = '${minimal_init}' }"
