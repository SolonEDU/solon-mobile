#!/bin/sh

# --batch to prevent interactive command --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" \
--output $GITHUB_WORKSPACE/android/app/my_secret.json $GITHUB_WORKSPACE/android/app/my_secret.json.gpg