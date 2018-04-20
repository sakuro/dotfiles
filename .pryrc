ENV.delete('PAGER')
Pry.config.prompt = ->(*) { '>> ' }
