HOSTNAME=$(shell hostname)

setup: link-git-hooks link-dotfiles install-locale install-packages change-login-shell

.PHONY: Brewfile.$(HOSTNAME)

link-git-hooks:
	ln -sf $(PWD)/scripts/post-merge .git/hooks

link-dotfiles:
	scripts/link-dotfiles.sh

install-locale:
	scripts/install-locale.sh

install-packages:
	scripts/install-packages.sh

change-login-shell:
	scripts/change-login-shell.sh

install-asdf-plugins:
	scripts/install-asdf-plugins.sh

dump-brewfile: Brewfile.$(HOSTNAME)

diff-brewfile: Brewfile.$(HOSTNAME)
	diff --unified Brewfile $< || exit 0

Brewfile.$(HOSTNAME):
	rm --force $@
	brew bundle dump --file=$@

shellcheck:
	shellcheck *.sh scripts/*.sh

up-to-date: update-packages clean-packages

clean-packages:
	brew cleanup --prune=all

update-packages:
	brew upgrade --verbose
