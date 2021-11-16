HOSTNAME=$(shell hostname)

setup: link-dotfiles install-packages change-login-shell

link-dotfiles:
	@scripts/link-dotfiles.sh

install-packages:
	@scripts/install-packages.sh

change-login-shell:
	@scripts/change-login-shell.sh

install-asdf:
	@scripts/install-asdf.sh

dump-brewfile: Brewfile.$(HOSTNAME)

Brewfile.$(HOSTNAME):
	@rm -f $@
	@brew bundle dump --file=$@
