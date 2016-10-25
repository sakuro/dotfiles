LINKED_FILES = Rake::FileList.new
LINKED_FILES.include('.*')
LINKED_FILES.exclude('.', '..')
LINKED_FILES.exclude('.git', '.gitignore', '.config')
LINKED_FILES.include('.config/git/ignore')
LINKED_FILES.exclude('.rbenv')
LINKED_FILES.include('.rbenv/default-gems')

LINKED_FILES.exclude('Library')
LINKED_FILES.include('Library/Preferences/RubyMine*/idea.vmoptions')

desc 'Make symlinks to dotfiles'
task :links

LINKED_FILES.each do |file|
  link = File.expand_path("~/#{file}")
  file link do
    mkdir_p File.dirname(link)
    ln_sf File.expand_path(file), link
  end
  Rake::Task[:links].enhance([link])
end
