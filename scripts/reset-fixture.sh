#!/usr/bin/env bash
# 把公开对端验收仓库复位到 fixture/main-baseline。
# publish-protected 受保护、不可写，无需复位。
# 需要对该仓库有写权限的 Git 凭据；可用 REPO_URL 指定仓库地址。
set -euo pipefail

repo_url=${REPO_URL:-https://github.com/ora-space/external-git-acceptance-public.git}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

git clone --quiet --no-checkout "$repo_url" "$work/repo"
cd "$work/repo"
git fetch --quiet origin '+refs/tags/fixture/*:refs/tags/fixture/*'

git push --quiet --force origin refs/tags/fixture/main-baseline:refs/heads/main

printf 'reset: main to fixture/main-baseline; publish-protected is protected and unchanged\n'
