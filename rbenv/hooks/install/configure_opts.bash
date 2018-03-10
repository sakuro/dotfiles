before_install 'export RUBY_CONFIGURE_OPTS="--enable-shared \
--disable-install-doc \
--with-opt-dir=/opt/local \
--with-readline-dir=/opt/local \
--with-libyaml-dir=/opt/local \
--with-openssl-dir=/opt/local \
--with-out-ext=tk"'

after_install 'unset RUBY_CONFIGURE_OPTS'
