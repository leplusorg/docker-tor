#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

cd "$(\dirname "${0}")"

if [ -f .bump.csv.bak ]; then
	if [ "$(\git status --porcelain=1 | wc -l)" -ne 0 ]; then
		>&2 echo "error: git repo contains uncommitted changes"
		exit 1
	fi
	\git pull
	csv="$(\cat .bump.csv.bak)"
	\rm -f .bump.csv.bak
	while IFS=',' read -r p v1 v2 l1 l2; do
		b="${p}-${v2//[\~\:]/-}"
		\git switch --create "${b}"
		\perl -i -p -e "s|\Q${l1}\E|${l2}|g" Dockerfile
		\git add Dockerfile
		\git commit -S -m "build(deps): bump ${p} from ${v1} to ${v2}"
		echo -n "Please review and push commit in branch \"${b}\". Waiting..."
		while ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1 ; do
			\sleep 1
			\echo -n .
		done
		\sleep 1
		\echo
		\gh pr create -f -l build -l dependencies
		\git checkout -
	done <<<"${csv}"
else
	>&2 echo "error: nothing to do"
	exit 1
fi
