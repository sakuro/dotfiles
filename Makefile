HOSTNAME=$(shell hostname)
TARGET_OS=$(shell ./scripts/detect-target-os.sh)
setup: link-git-hooks link-dotfiles install-packages change-login-shell

.PHONY: files/Brewfile.$(HOSTNAME)

link-git-hooks: .git/hooks/post-merge

.git/hooks/post-merge:
	mkdir -p $$(dirname $@)
	ln -s -f $(PWD)/scripts/post-merge $$(dirname $@)

link-dotfiles:
	@scripts/link-dotfiles.sh

install-packages:
	@scripts/$(TARGET_OS)/install-packages.sh

update-packages:
	@scripts/$(TARGET_OS)/update-packages.sh

clean-packages:
	@scripts/$(TARGET_OS)/clean-packages.sh

change-login-shell:
	@scripts/change-login-shell.sh

dump-brewfile: files/Brewfile.$(HOSTNAME)

diff-brewfile: files/Brewfile.$(HOSTNAME)
	diff --unified files/Brewfile $< || exit 0

clean-brewfile:
	@rm -v files/Brewfile.$(HOSTNAME).*

files/Brewfile.$(HOSTNAME):
	-[ -f $@ ] && ./bin/rotate-suffix $@
	brew bundle dump --file=$@

shellcheck:
	shellcheck scripts/*.sh scripts/*/*.sh
