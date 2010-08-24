jerk = require './vendor/Jerk/lib/jerk'

# lame config, weee

options = {
  server: 'irc.freenode.net',
  nick: 'coffeebot__',
  channels: ['#%mule', '#coffeescript'],
  csLocation: '../coffee-script'
}

spawn = require('child_process').spawn

CoffeeScript = require options.csLocation + '/lib/coffee-script'
csVersion = CoffeeScript.VERSION

jerk((j) ->
  j.watch_for /^cs>(.*)$/, (message) ->
    try
      timer = null
      js = CoffeeScript.compile message.match_data[1], noWrap: true
      
      stdout = ''
      stderr = ''
      output = (data) ->
        stdout += if !!data then data else ''
      errOut = (data) ->
        stderr += if !!data then data else ''
      child = spawn 'node', ['runner.js']
      child.stdout.addListener 'data', output
      child.stderr.addListener 'data', errOut
      child.addListener 'exit', (exitCode) ->
        clearTimeout(timer)
        
        if stdout == ''
          console.log 'empty!'
          stdout = stderr

        message.say if stdout? then stdout else 'error. hm.'
      
      child.stdin.write js
      child.stdin.end()
      
      timeoutCallback = ->
        child.stdout.removeListener 'output', output
        child.stderr.removeListener 'errOut', errOut

        stdout = "TimeoutError"
        child.kill()
      
      timer = setTimeout(timeoutCallback, 1000)
      
      
    catch e # error parsing the CS
      message.say if e.stack? then e.split("\n")[0] else e.toString()    

  j.watch_for /^!quit/, (message) ->
    process.exit(0)
  
  j.watch_for /^!version/, (message) ->
    message.say "I'm running CoffeeScript v"+csVersion
).connect options
