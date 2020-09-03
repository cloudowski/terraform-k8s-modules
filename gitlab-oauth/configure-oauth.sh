#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -x

exec 2> /tmp/gitlab_oauth_dbg.log

cat <<EOF | http --pretty none "$GITLAB_URL/api/v4/applications" "Private-Token: $TOKEN" >&2
{
"name": "$NAME",
"redirect_uri": "$REDIRECT_URI",
"scopes": "$SCOPES"
}
EOF
    