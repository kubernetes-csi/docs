#!/bin/bash
#
# Copied from https://gist.github.com/domenic/ec8b0fc8ab45f39403dd.

set -e # Exit with nonzero exit code if anything fails
set -x # Dump commands.

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"
WORKDIR=docs

function doCompile {
    make all
}

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    doCompile
    exit 0
fi

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Clone the existing gh-pages for this repo into docs/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy).
# Otherwise we need to fetch the branch so that we can append to it.
git fetch --depth=1 origin refs/heads/$TARGET_BRANCH:refs/heads/origin/$TARGET_BRANCH || true
git clone --no-checkout $REPO $WORKDIR
cd $WORKDIR
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd ..

# Save .git directory, mdbook would remove it otherwise.
mv $WORKDIR/.git $WORKDIR-git

# Run our compile script
doCompile

# Restore .git directory.
mv $WORKDIR-git $WORKDIR/.git

# Now let's go have some fun with the cloned repo
cd $WORKDIR
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A .

# If there are no changes to the compiled $WORKDIR (e.g. this is a README update) then just bail.
# Patrick Ohly: the original script ran "git diff" first without staging all files,
# which didn't pick up changes to files unknown to git.
if git diff --cached --quiet; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

git commit -m "Deploy to GitHub Pages: ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in ../hack/deploy_key.enc -out ../deploy_key -d
chmod 600 ../deploy_key
eval `ssh-agent -s`
ssh-add ../deploy_key

# Now that we're all set up, we can push.
git push $SSH_REPO $TARGET_BRANCH
