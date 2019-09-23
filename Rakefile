require 'uri'
require 'pathname'
require 'rake/clean'

INSTALLER_URL = URI('https://raw.githubusercontent.com/Homebrew/install/master/install')
ORIGINAL_BREW_ROOT = '/usr/local'
BREW_ROOT = '/opt/brew'
BINDIR = 'bin'
CLEAN.include BINDIR

INSTALLER_PATH = File.join(BINDIR, File.basename(INSTALLER_URL.path))
BREW_PATH = File.join(BREW_ROOT, 'bin', 'brew')

task default: :bundle

directory BINDIR

file INSTALLER_PATH => BINDIR do |t|
  IO.popen("curl -fsSL #{INSTALLER_URL}") do |io|
    File.write(t.name, io.read.gsub(ORIGINAL_BREW_ROOT, BREW_ROT))
  end
  chmod 'u+rx', t.name
end

file BREW_PATH => INSTALLER_PATH do |t|
  sh t.prerequisites[0]
end

task bundle: BREW_PATH do |t|
  sh t.prerequisites[0], 'bundle'
end

# ```
# $ dot set
# ```
