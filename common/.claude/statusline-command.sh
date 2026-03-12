#!/usr/bin/env bash
set -eu

input=$(cat | tee $HOME/.claude/last-status.json)

query () {
    jq -r "$@" <<< "$input"
}

dirname=$(basename "$(query .cwd)")
model=$(query .model.display_name)
ctx_used=$(query '.context_window.used_percentage // 0')
session_cost=$(query .cost.total_cost_usd)

red=$'\033[31m'
green=$'\033[32m'
cyan=$'\033[36m'
bold_green=$'\033[01;32m'
purple=$'\033[1;38;5;127m'
bold_blue=$'\033[01;34m'
orange=$'\033[1;38;5;208m'
reset=$'\033[00m'

repeat () {
    local str=$1
    local n=$2
    for i in $(seq $n); do echo -n "$str"; done
}

bar_width=20
ctx_left=$((100 - ctx_used))
filled=$((ctx_used * bar_width / 100))
empty=$((bar_width - filled))
ctx_bar="${cyan}$(repeat '▓' $filled)$(repeat '░' $empty)${reset}"

timestamp="${bold_green}[$(date +%H:%M:%S)]${reset}"
model_name="${orange}${model}${reset}"
hostname="${purple}$(hostname -s)${reset}"
directory="${bold_blue}${dirname}${reset}"
cost="${green}\$$(printf '%.02f' $session_cost)${reset}"
context="$(printf '%3d%%' $ctx_used) $ctx_bar $(printf '%d%%' $ctx_left)"
echo "$timestamp $model_name@$hostname $directory $cost $context"
