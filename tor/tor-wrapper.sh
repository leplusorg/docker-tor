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
	if [ "${DEBUG}" = true ]; then
		\echo 'DEBUG: Found existing /etc/torrc, overwritting /etc/tor/torrc.'
	fi
	\cp -f '/etc/torrc' '/etc/tor/torrc'
	\echo 'WARN: Found configuration file at deprecated location /etc/torrc. Please use /etc/tor/torrc instead or it will stop working in future releases of this image.'
fi
if [ -n "${SKIP_TEMPLATE+x}" ]; then
	if [ "${DEBUG}" = true ]; then
		\echo "DEBUG: Skipping templating since SKIP_TEMPLATE is set."
	fi
	\echo "Skipping templating."
else
	if [ "${DEBUG}" = true ]; then
		\echo "DEBUG: Using template since SKIP_TEMPLATE is not set."
	fi
	if [ -f '/etc/tor/torrc' ]; then
		>&2 \echo "ERROR: Cannot use both configuration template and provided torrc file. Either remove the torrc file or set SKIP_TEMPLATE to use provided torrc."
		exit 1
	fi
	if [ -n "${SHELL_FORMAT+x}" ]; then
		if [ "${DEBUG}" = true ]; then
			\echo "DEBUG: Found custom Shell Format for envsubst: ${SHELL_FORMAT}"
		fi
	elif [ -n "${SHELL_FORMAT_EXTRA+x}" ]; then
		if [ "${DEBUG}" = true ]; then
			\echo "DEBUG: Found extra Shell Format for envsubst: ${SHELL_FORMAT_EXTRA}"
		fi
		# Escaping predefined variables names except
		# SHELL_FORMAT_EXTRA, as we don't want them to be
		# expanded.
		SHELL_FORMAT="\${DATA_DIRECTORY},\${LOG_LEVEL},\${LOG_FILE},\${SOCKS_HOSTNAME},\${SOCKS_PORT},\${TORRC_APPEND},${SHELL_FORMAT_EXTRA}"
	else
		# Using single quotes here on purpose, we don't want the
		# variables names to be expanded.
		# shellcheck disable=SC2016
		SHELL_FORMAT='${DATA_DIRECTORY},${LOG_LEVEL},${LOG_FILE},${SOCKS_HOSTNAME},${SOCKS_PORT},${TORRC_APPEND}'
	fi
	DATA_DIRECTORY="${DATA_DIRECTORY:-/var/lib/tor}" \
		LOG_LEVEL="${LOG_LEVEL:-notice}" \
		LOG_FILE="${LOG_FILE:-stdout}" \
		SOCKS_HOSTNAME="${SOCKS_HOSTNAME:-127.0.0.1}" \
		SOCKS_PORT="${SOCKS_PORT:-9050}" \
		TORRC_APPEND="${TORRC_APPEND:-}" \
		envsubst "${SHELL_FORMAT}" </etc/tor/torrc.template >/etc/tor/torrc
fi

if [ "${DEBUG}" = true ]; then
	\echo 'DEBUG: Content of /etc/tor/torrc:'
	\echo 'DEBUG: =========================='
	\sed -e 's/^/DEBUG: /' /etc/tor/torrc
	\echo 'DEBUG: =========================='
fi

\chown -R "$(id -u):$(id -g)" "${DATA_DIRECTORY:-/var/lib/tor}"

cmd=$(\which tor)

exec "${cmd}" -f /etc/tor/torrc "$@"
