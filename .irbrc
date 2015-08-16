# common typos
alias rquire require

END { puts }

# Invoke pry if available
begin
  require 'pry'
  Pry.start
  exit
rescue LoadError
  require 'irb/ext/save-history'
  require 'irb/completion'

  IRB.conf[:USE_READLINE] = true
  IRB.conf[:SAVE_HISTORY] = 10000
  IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb.history')
  IRB.conf[:PROMPT_MODE] = :SIMPLE
  puts 'Invoking irb'
end
