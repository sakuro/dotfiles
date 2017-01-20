ZPLUG_DIR = File.expand_path('~/.zsh.d/zplug')

desc 'Install zplug'
task :zplug => [ ZPLUG_DIR ]

directory ZPLUG_DIR do
  sh "git clone https://github.com/zplug/zplug #{ZPLUG_DIR}"
end
