#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# debug mode is off by default
if [ -z "${DEBUG+x}" ]; then
	DEBUG=false
fi

# Honoring GitHub runner debug mode
if [ -n "${RUNNER_DEBUG+x}" ] && [ "${RUNNER_DEBUG}" = 1 ]; then
	DEBUG=true
fi

if [ "${DEBUG}" = true ]; then
	set -o xtrace
fi

if [ -f '/etc/torrc' ]; then
	\echo 'WARN: Ignoring /etc/torrc, new location is /etc/tor/torrc.'
fi

if [ -f /etc/tor/torrc ]; then
	\echo 'INFO: Found existing /etc/tor/torrc file, skipping template.'
else
	SOCKS_HOSTNAME="${SOCKS_HOSTNAME:-127.0.0.1}" \
		SOCKS_PORT="${SOCKS_PORT:-9050}" \
		envsubst </etc/tor/torrc.sample >/etc/tor/torrc
fi

cmd=$(\which tor)

"${cmd}" "$@"
