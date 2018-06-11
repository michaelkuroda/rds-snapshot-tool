#!/bin/bash


dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
src=$dir/../lambda
builder=$dir/builder

lambdas=(
	"copy_snapshots_dest_rds"
	"copy_snapshots_no_x_account_rds"
	"delete_old_snapshots_dest_rds"
	"delete_old_snapshots_no_x_account_rds"
	"delete_old_snapshots_rds"
	"share_snapshots_rds"
	"take_snapshots_rds")

function clean_up
{
  rm -rf node_modules
  rm -rf "$builder"
}

function highlight
{
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ${2:--}
  echo $1
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ${2:--}
}

trap clean_up INT TERM EXIT

mkdir -p "$builder"
npm install

for i in "${lambdas[@]}"
do
    echo "$i"
	cp "$src"/snapshots_tool_utils.py "$src"/"$i"/snapshots_tool_utils.py
	npm run zip -- ../lambda/"$i".zip ../lambda/snapshots_tool_utils.py ../lambda/"$i"/lambda_function.py
done

