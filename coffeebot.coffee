jerk = require './vendor/Jerk/lib/jerk'
options = require './options'
Sandbox = require './sandbox'

jerk((j) ->
  j.watch_for /^cs>(.*)$/, (message) ->
    sb = new Sandbox message.match_data[1], options.coffeeBin
    sb.run (result) ->
      message.say "#{message.user}: #{result}"

  j.watch_for /^!quit/, (message) ->
    process.exit(0)
  
  j.watch_for /^!version/, (message) ->
    message.say "I'm running CoffeeScript v0"
).connect options
