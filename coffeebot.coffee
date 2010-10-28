jerk = require './vendor/Jerk/lib/jerk'
options = require './options'
Sandbox = require './sandbox'
CSNodePrint = require './csnodeprint'
git = require './gitinterface'

bot = jerk((j) ->
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
  
  j.watch_for /^!help/, (message) ->
    msg = 'Commands that coffeebot responds to:\n'
    msg +='cs> 1 + 1 # evals this code and prints the result. If the result exceeds 1 line or 512 characters, the result is made into a gist and a url is furnished.\n'
    msg +='csn> 1 + 1 # same as cs>, but prints the CoffeeScript nodes to a gist. Equiv. to `coffee -n`.\n'
    msg +='!version # prints version info for the bot.\n'
    msg +='!help # prints this message.\n'
    bot.say(message.user, msg)
).connect options
