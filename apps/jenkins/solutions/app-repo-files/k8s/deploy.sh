#!/usr/bin/env bash

set -e
set -x

TARGET_ENV=$1
[ -z "$TARGET_ENV" ] && { echo "Usage: $0 ENV_TO_DEPLOY" >&2; exit 2; }

k="kubectl -n pets-$TARGET_ENV"

$k apply -f config/$TARGET_ENV
$k apply -f db/
#$k apply -f rs/
$k apply -f deploy/
$k apply -f svc/
$k apply -f ingress/$TARGET_ENV
