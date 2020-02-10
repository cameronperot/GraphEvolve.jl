#!/bin/bash
set -euf -o pipefail

julia ./docs/make.jl

tmp_dir="/tmp/GraphEvolve.jl/docs"

if [ -d "$tmp_dir" ]; then
    rm -rf "$tmp_dir"
fi

mkdir -p "$tmp_dir"
cp -a ./docs/build/. "$tmp_dir/"

git stash
git switch gh-pages
cp -a "$tmp_dir/." ./

git add .
git commit -m "Updated documentation"
git push

git switch master
git stash pop
