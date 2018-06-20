after_install 'export RBENV_VERSION="$VERSION_NAME"; \
gem update --system; \
rehash; \
gem uninstall rubygems-update --all --executables; \
gem -v'
