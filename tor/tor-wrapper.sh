#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

declare -l DEBUG
# debug mode is off by default
DEBUG="${DEBUG:-false}"

declare -l SKIP_TEMPLATE
# skip template mode is off by default
SKIP_TEMPLATE="${SKIP_TEMPLATE:-false}"

declare -l SET_PERMISSIONS
# set permissions mode is on by default
SET_PERMISSIONS="${SET_PERMISSIONS:-true}"

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
		echo 'DEBUG: Found existing /etc/torrc, overwritting /etc/tor/torrc.'
	fi
	\cp -f '/etc/torrc' '/etc/tor/torrc'
	echo 'WARN: Found configuration file at deprecated location /etc/torrc. Please use /etc/tor/torrc instead or it will stop working in future releases of this image.'
fi
if [ "${SKIP_TEMPLATE}" = true ]; then
	if [ "${DEBUG}" = true ]; then
		echo "DEBUG: Skipping templating since SKIP_TEMPLATE is set."
	fi
	echo "Skipping templating."
else
	if [ "${DEBUG}" = true ]; then
		echo "DEBUG: Using template since SKIP_TEMPLATE is not set."
	fi
	if [ -f '/etc/tor/torrc' ]; then
		echo "WARN: /etc/tor/torrc will be overwritten using template /etc/tor/torrc.template (set SKIP_TEMPLATE=true to disable this)."
	fi
	if [ -n "${SHELL_FORMAT+x}" ]; then
		if [ "${DEBUG}" = true ]; then
			echo "DEBUG: Found custom Shell Format for envsubst: ${SHELL_FORMAT}"
		fi
	elif [ -n "${SHELL_FORMAT_EXTRA+x}" ]; then
		if [ "${DEBUG}" = true ]; then
			echo "DEBUG: Found extra Shell Format for envsubst: ${SHELL_FORMAT_EXTRA}"
		fi
		# Escaping predefined variables names except
		# SHELL_FORMAT_EXTRA, as we don't want them to be
		# expanded.
		SHELL_FORMAT="\${DATA_DIRECTORY},\${LOG_LEVEL},\${LOG_FILE},\${SOCKS_HOSTNAME},\${SOCKS_PORT},\${TORRC_APPEND},${SHELL_FORMAT_EXTRA}"
	else
		# Using single quotes here on purpose, we don't want the
		# variables names to be expanded.
		# shellcheck disable=SC2016 # [Expressions don't expand in single quotes]: on purpose
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
	echo 'DEBUG: Content of /etc/tor/torrc:'
	echo 'DEBUG: =========================='
	\sed -e 's/^/DEBUG: /' /etc/tor/torrc
	echo 'DEBUG: =========================='
fi

if [ "${SET_PERMISSIONS}" = true ]; then
	if [ "${DEBUG}" = true ]; then
		echo "DEBUG: Adjusting permissions on ${DATA_DIRECTORY:-/var/lib/tor}."
	fi
	# As per https://gitlab.torproject.org/tpo/core/tor/-/blob/main/src/lib/fs/dir.c
	\chown "$(id -u):$(id -g)" "${DATA_DIRECTORY:-/var/lib/tor}"
	\chmod g-rwx,o-rwx "${DATA_DIRECTORY:-/var/lib/tor}"
fi

cmd=$(\which tor)

exec "${cmd}" -f /etc/tor/torrc "$@"
