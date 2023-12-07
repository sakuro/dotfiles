HOSTNAME=$(shell hostname)

setup: link-git-hooks link-dotfiles install-locale install-packages change-login-shell

.PHONY: Brewfile.$(HOSTNAME)

link-git-hooks: .git/hooks/post-merge

.git/hooks/post-merge:
	mkdir -p $$(dirname $@)
	ln -s -f $(PWD)/scripts/post-merge $$(dirname $@)

link-dotfiles:
	@scripts/link-dotfiles.sh

install-locale:
	@scripts/install-locale.sh

install-packages:
	@scripts/install-packages.sh

change-login-shell:
	@scripts/change-login-shell.sh

install-asdf-plugins:
	@scripts/install-asdf-plugins.sh

dump-brewfile: Brewfile.$(HOSTNAME)

diff-brewfile: Brewfile.$(HOSTNAME)
	diff --unified Brewfile $< || exit 0

clean-brewfile:
	@rm -v Brewfile.$(HOSTNAME).*

Brewfile.$(HOSTNAME):
	@scripts/rotate-brewfiles.sh
	brew bundle dump --file=$@

shellcheck:
	shellcheck *.sh scripts/*.sh

up-to-date: update-packages clean-packages

clean-packages:
	@scripts/clean-packages.sh

update-packages:
	@scripts/update-packages.sh
