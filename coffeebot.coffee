jerk = require './vendor/Jerk/lib/jerk'
options = require './options'
Sandbox = require './sandbox'
CSNodePrint = require './csnodeprint'

jerk((j) ->
  j.watch_for /^cs>(.*)$/, (message) ->
    sb = new Sandbox message.match_data[1], options.coffeeBin
    sb.run (result) -> message.say "#{message.user}: #{result}"
  
  j.watch_for /^csn>(.*)$/, (message) ->
    csn = new CSNodePrint message.match_data[1], options.coffeeBin, options.gistBin
    csn.run (result) -> message.say "#{message.user}: #{result}"

  j.watch_for /^!quit/, (message) ->
    process.exit(0)
  
  j.watch_for /^!version/, (message) ->
    sb = new Sandbox '__get_cs_version', options.coffeeBin
    sb.run (result) -> message.say result
).connect options
