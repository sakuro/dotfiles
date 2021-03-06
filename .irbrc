# common typos
alias rquire require

# useful stdlibs
require 'date'
require 'fileutils'
require 'pathname'
require 'time'

END { puts }

# Prefer reline
begin
  require 'reline'
  puts 'Using reline'
rescue LoadError
  require 'readline'
  puts 'Using readline'
ensure
  IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb.history')
end

require 'irb/ext/save-history'
require 'irb/completion'

IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:PROMPT_MODE] = :SIMPLE
