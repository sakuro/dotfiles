HOSTNAME=$(shell hostname)
TARGET_OS=$(shell ./scripts/detect-target-os.sh)
export TARGET_OS

setup: link-git-hooks link-dotfiles

.PHONY: setup link-git-hooks link-dotfiles

link-git-hooks: .git/hooks/post-merge

.git/hooks/post-merge:
	mkdir -p $$(dirname $@)
	ln -s -f $(PWD)/scripts/post-merge $$(dirname $@)

link-dotfiles:
	@scripts/link-dotfiles.sh
