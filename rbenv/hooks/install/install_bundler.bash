after_install 'export RBENV_VERSION="$VERSION_NAME"; \
gem list | grep -q bundler || gem install bundler'
