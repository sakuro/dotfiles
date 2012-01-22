# -*- encoding: UTF-8 -*-

require 'irb/ext/save-history'
require 'irb/completion'

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb.history')
IRB.conf[:PROMPT_MODE] = :SIMPLE

# common typos
alias rquire require

END { puts }
