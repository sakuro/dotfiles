HOSTNAME=$(shell hostname)

setup: link-dotfiles install-packages change-login-shell

.PHONY: Brewfile.$(HOSTNAME)

link-dotfiles:
	@scripts/link-dotfiles.sh

install-packages:
	@scripts/install-packages.sh

change-login-shell:
	@scripts/change-login-shell.sh

install-asdf-plugins:
	@scripts/install-asdf-plugins.sh

dump-brewfile: Brewfile.$(HOSTNAME)

Brewfile.$(HOSTNAME):
	@rm -f $@
	@brew bundle dump --file=$@