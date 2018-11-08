#!/bin/sh -e
#
# Updates book/src/Example.md with the latest revisions of all referenced files.
# While doing so it prints a diff between files and a commit log.
#
# Updating the links to files embedded in the docs repo itself together
# with the Readme.md is a bit harder:
# - commit the updated .yaml files locally
# - manually update the revision hash
# - submit the PR *without* touching the updated .yaml files
#
# It's easier to update the .yaml files, submit a PR, and then
# once accepted, update the example using this script.

example=book/src/Example.md

for url in $(grep 'kubectl create -f.*https://raw.githubusercontent.com/' $example | sed -e 's;.*\(https://raw.githubusercontent.com[^ (]*\).*;\1;'); do
    # split URL into pieces
    eval $(echo $url | sed -e 's/\]$//' -e 's;https://raw.githubusercontent.com/\([^/]*/[^/]*\)/\([^/]*\)/\(.*\);repo=\1 rev=\2 file=\3;')
    git fetch https://github.com/$repo refs/heads/master:refs/remotes/$repo/master
    echo $repo/$file
    set -x
    git log $rev..$repo/master -- $file | cat
    git diff $rev..$repo/master -- $file | cat
    set +x
    echo
    latest=$(git rev-list --max-count=1 $repo/master)
    sed -i \
        -e "s;https://raw.githubusercontent.com/$repo/$rev/$file;https://raw.githubusercontent.com/$repo/$latest/$file;" \
        -e "s;https://github.com/$repo/blob/$rev/$file;https://github.com/$repo/blob/$latest/$file;" \
        $example
done
