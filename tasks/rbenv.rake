RBENV_DIR = File.expand_path('~/.rbenv')

RBENV_PLUGIN_REPOS = %w(
  rbenv/rbenv-default-gems
  rkh/rbenv-update
  rbenv/ruby-build
  rbenv/rbenv-each
)

desc 'Install rbenv'
task :rbenv => [ RBENV_DIR, 'rbenv:plugins' ]

directory RBENV_DIR do
  sh "git clone https://github.com/rbenv/rbenv #{RBENV_DIR}"
end

namespace :rbenv do
  desc 'Install rbenv plugins'
  task :plugins => RBENV_DIR

  desc 'Update rbenv and plugins'
  task :update do
    sh 'rbenv update'
  end

  namespace :plugins do
    RBENV_PLUGIN_REPOS.each do |plugin_repo|
      _owner, plugin_name = plugin_repo.split('/')
      plugin_dir = File.join(RBENV_DIR, "plugins/#{plugin_name}")

      task plugin_name => plugin_dir
      directory plugin_dir => RBENV_DIR do
        repo_url = "https://github.com/#{plugin_repo}.git"
        sh "git clone #{repo_url} #{plugin_dir}"
      end

      Rake::Task[:"rbenv:plugins"].enhance([:"rbenv:plugins:#{plugin_name}"])
    end
  end
end
