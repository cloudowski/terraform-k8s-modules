#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -x
# exec 2> /tmp/dbg.log

cat <<EOF | http --pretty none "$GITLAB_URL/api/v4/users" "Private-Token: $TOKEN" >&2
{
"email": "${NAME}@example.com",
"skip_confirmation": "true",
"can_create_group": "true",
"password": "$PASSWORD",
"name": "$NAME",
"username": "$NAME"
}
EOF
    