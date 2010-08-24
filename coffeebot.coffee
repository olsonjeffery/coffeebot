jerk = require './vendor/Jerk/lib/jerk'

# lame config, weee

options = {
  server: 'irc.freenode.net',
  nick: 'coffeebot__',
  channels: ['#%mule', '#coffeescript'],
  csLocation: '../coffee-script'
}


Sandbox = require './lib/sandbox'
sb = null
reset = ->
  sb = new Sandbox()
reset()

CoffeeScript = require options.csLocation + '/lib/coffee-script'

jerk((j) ->
  j.watch_for /^cs>(.*)$/, (message) ->
    try
      #
      js = CoffeeScript.compile message.match_data[1], noWrap: true
      
      sb.run js, (output) ->
        result = output # if output isnt undefined then output else 'undefined'
        message.say result
    catch e
      message.say if e.stack isnt undefined then e.stack.split("\n")[0] else e.toString()    

  j.watch_for /^!quit/, (message) ->
    process.exit(0)
).connect options
