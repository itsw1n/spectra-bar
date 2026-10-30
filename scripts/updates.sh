#!/usr/bin/env bash
count=0
if command -v checkupdates >/dev/null 2>&1; then
  count=$(checkupdates 2>/dev/null | wc -l)
fi
if (( count > 0 )); then
  printf '{"text":"󰏔 %d","tooltip":"%d package updates available"}\n' "$count" "$count"
else
  printf '{"text":"󰏓","tooltip":"No package updates found"}\n'
fi
