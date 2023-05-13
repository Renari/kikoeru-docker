#!/bin/bash
set -Eeuo pipefail

mkdir -p /voice
# set default voice location to /voice
sed -i 's/"rootDir": ".*"/"rootDir": "\/voice"/' ${ROOT}/config.json

# init db
node ${ROOT}/dist/server/filesystem/scanner.js

declare -A MOUNTS

MOUNTS["${ROOT}/db.sqlite3"]="/data/db.sqlite3"
MOUNTS["${ROOT}/config.json"]="/data/config.json"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  if test -d "${to_path}"; then
    if [ ! -f "$from_path" ]; then
      mkdir -vp "$from_path"
    fi
    ln -sT "${from_path}" "${to_path}"
    mkdir -vp "$(dirname "${to_path}")"
  else
    if [ -f "${from_path}" ]; then
      rm "${to_path}"
    else
      mv "${to_path}" "${from_path}"
    fi
    ln -s "${from_path}" "${to_path}"
  fi
  echo Mounted $(basename "${from_path}")
done

exec "$@"
