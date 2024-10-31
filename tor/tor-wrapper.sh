#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# debug mode is off by default
if [ -z "${DEBUG+x}" ]; then
	DEBUG=false
fi

# Honoring GitHub runner debug mode
if [ -n "${RUNNER_DEBUG+x}" ] && [ "${RUNNER_DEBUG}" = 1 ]; then
	DEBUG=false
fi

if [ "${DEBUG}" = true ]; then
	set -o xtrace
	LOG_LEVEL=debug
fi

if [ -f '/etc/torrc' ]; then
	\echo 'WARN: Ignoring /etc/torrc, new location is /etc/tor/torrc.'
fi


if [ -z "${SHELL_FORMAT+x}" ]; then
	# Using single quotes here on purpose, we don't want the
	# variables names to be expanded.
	SHELL_FORMAT='${DATA_DIRECTORY},${LOG_LEVEL},${LOG_FILE},${SOCKS_HOSTNAME},${SOCKS_PORT}'
else
    \echo "DEBUG: Found custom Shell Format for envsubst: ${SHELL_FORMAT}"
fi

DATA_DIRECTORY="${DATA_DIRECTORY:-/var/lib/tor}" \
	LOG_LEVEL="${LOG_LEVEL:-notice}" \
	LOG_FILE="${LOG_FILE:-stdout}" \
	SOCKS_HOSTNAME="${SOCKS_HOSTNAME:-127.0.0.1}" \
	SOCKS_PORT="${SOCKS_PORT:-9050}" \
	envsubst "${SHELL_FORMAT}" </etc/tor/torrc.template >/etc/tor/torrc

if [ "${DEBUG}" = true ]; then
    \echo 'DEBUG: Content of /etc/tor/torrc:'
    \echo 'DEBUG: =========================='
    \cat /etc/tor/torrc | \sed -e 's/^/DEBUG: /'
    \echo 'DEBUG: =========================='
fi

cmd=$(\which tor)

"${cmd}" -f /etc/tor/torrc "$@"
