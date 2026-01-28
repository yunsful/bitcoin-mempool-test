#!/usr/bin/env bash
set -euo pipefail

DATADIR="${BITCOIN_DATADIR:-/data}"
CONF_FILE="${BITCOIN_CONF:-/config/bitcoin.conf}"
EXTRA_ARGS=()

if [ -n "${BITCOIN_ARGS:-}" ]; then
  # shellcheck disable=SC2206
  EXTRA_ARGS=( ${BITCOIN_ARGS} )
fi

mkdir -p "${DATADIR}"
chown -R bitcoin:bitcoin "${DATADIR}"

if [ -f "${CONF_FILE}" ]; then
  exec gosu bitcoin "$@" -conf="${CONF_FILE}" -datadir="${DATADIR}" "${EXTRA_ARGS[@]}"
fi

exec gosu bitcoin "$@" -datadir="${DATADIR}" "${EXTRA_ARGS[@]}"
