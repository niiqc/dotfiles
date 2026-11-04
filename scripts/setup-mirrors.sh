#!/usr/bin/env bash
set -e
git remote set-url origin git@git.sr.ht:~niqc/dotfiles
git config --unset-all remote.origin.pushurl || true
for url in \
		git@git.sr.ht:~niqc/dotfiles \
		git@codeberg.org:niqc/dotfiles.git \
		git@github.com:niiqc/dotfiles.git
do
		git remote set-url --add --push origin "$url"
done
git config push.followTags true
