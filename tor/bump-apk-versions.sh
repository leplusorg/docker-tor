#!/bin/sh
# shellcheck shell=dash

set -euo pipefail

cd "$(\dirname "${0}")"

if [ -f /.dockerenv ]; then

	\apk update

	\apk add perl

	u=$(\apk -u list | \tr '\n' '|')

	\sed -e :a -e '/\\$/N; s/\\\n//; ta' Dockerfile | \grep -o -e 'apk[^\&\;]*add[^\&\;]*' | \grep -o -e '[^ ]*=[^ ]*' | while IFS= \read -r l; do
		p="${l%=*}"
		v1="${l#*=}"
		v="$(\echo "|${u}" | \grep -o -e "\|${p}-[^\|]*upgradable from: ${p}-${v1}" || true)"
		if [ -z "${v}" ]; then
			continue
		fi
		n=$(($(\echo -n "${p}" | wc -c) + 2))
		v2="$(\echo "${v}" | \cut -d ' ' -f 1 | \cut -c ${n}-)"
		if [ -n "${v2}" ] && [ "${v2}" != "${v1}" ]; then
			\echo "${p} ${v1} -> ${v2}"
			\perl -i -p -e "s|\Q${l}\E|${p}=${v2}|g" Dockerfile
		fi
	done

else

	\docker run --pull always --rm -t --user root -v "$(pwd):/opt/bump" "leplusorg/${PWD##*/}:main" /opt/bump/"$(\basename "${0}")"

fi
