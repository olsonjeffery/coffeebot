jerk = require './vendor/Jerk/lib/jerk'
options = require './options'
Sandbox = require './sandbox'
CSNodePrint = require './csnodeprint'
git = require './gitinterface'

jerk((j) ->
  j.watch_for /^cs>(.*)$/, (message) ->
    csCode = message.match_data[1]
    sb = new Sandbox csCode, options.coffeeBin
    sb.run (result) -> 
      if result.split("\n").length > 1 or result.length > 512
        gistContent = "#{message.user}'s input:\n>#{csCode}\n\noutput:\n#{result}"
        git.postGist(gistContent, options.gistBin, (o) -> message.say("#{message.user}: #{o}"))
      else
        message.say "#{message.user}: #{result}"
  
  j.watch_for /^csn>(.*)$/, (message) ->
    csn = new CSNodePrint message.match_data[1], options.coffeeBin, options.gistBin
    csn.run (result) -> message.say "#{message.user}: #{result}"

  j.watch_for /^!quit/, (message) ->
    process.exit(0)
  
  j.watch_for /^!version/, (message) ->
    sb = new Sandbox '__get_cs_version', options.coffeeBin
    sb.run (result) -> message.say result
).connect options
