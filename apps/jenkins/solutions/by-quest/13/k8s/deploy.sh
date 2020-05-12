#!/usr/bin/env bash

set -e
set -x

TARGET_ENV=$1
[ -z "$TARGET_ENV" ] && { echo "Usage: $0 ENV_TO_DEPLOY" >&2; exit 2; }

k="kubectl -n pets-$TARGET_ENV"

$k apply -R -f environments/$TARGET_ENV
