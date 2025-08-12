#!/bin/bash

set -euo pipefail

cd "$(\dirname "${0}")"

if [ -f .bump.csv.bak ]; then
	if [ "$(\git status --porcelain=1 | wc -l)" -ne 0 ]; then
		>&2 echo "error: git repo contains uncommitted changes"
		exit 1
	fi
	csv="$(\cat .bump.csv.bak)"
	\rm -f .bump.csv.bak
	while IFS="," read -r p v1 v2 l1 l2; do
		b="${p}-${v2}"
		\git switch --create "${b}"
		\perl -i -p -e "s|\Q${l1}\E|${l2}|g" Dockerfile
		\git add Dockerfile
		\git commit -S -m "build(deps): bump ${p} from ${v1} to ${v2}"
		read -n 1 -s -r -p "Please review and push commit in branch \"${b}\". Press enter to continue..."
		\gh pr create -f -l build -l dependencies
		\git checkout -
	done <<<"${csv}"
else
	>&2 echo "error: nothing to do"
	exit 1
fi
