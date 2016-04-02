ENV['RUBY_CONFIGURE_OPTS'] = %w(
  --enable-shared
  --disable-install-doc
  --with-opt-dir=/opt/local
  --with-readline-dir=/opt/local
  --with-openssl-dir=/opt/local
  --with-libyaml-dir=/opt/local
  --with-out-ext=tk
).join(' ')

desc 'Install ruby'
task :ruby, :version do |t, arguments|
  version = arguments[:version]
  sh "rbenv install #{version}"
end
