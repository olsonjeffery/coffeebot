jerk = require './vendor/Jerk/lib/jerk'
options = require('./options')
spawn = require('child_process').spawn

jerk((j) ->
  j.watch_for /^cs>(.*)$/, (message) ->
    try
      timer = null
      stdout = ''
      stderr = ''
      output = (data) ->
        stdout += if !!data then data else ''
      errOut = (data) ->
        stderr += if !!data then data else ''
      child = spawn options.coffeeBin, ['runner.coffee']
      child.stdout.addListener 'data', output
      child.stderr.addListener 'data', errOut
      child.addListener 'exit', (exitCode) ->
        clearTimeout(timer)
        if stdout == ''
          stdout = stderr
        message.say if stdout? then "#{message.user}: #{stdout}" else 'error. hm.'
      
      code = message.match_data[1]
      child.stdin.write code
      child.stdin.end()
      
      timeoutCallback = ->
        child.stdout.removeListener 'output', output
        child.stderr.removeListener 'errOut', errOut

        stdout = "TimeoutError"
        child.kill()
      
      timer = setTimeout(timeoutCallback, 5000)
      
      
    catch e # error parsing the CS
      message.say if e.stack? then e.split("\n")[0] else e.toString()    

  j.watch_for /^!quit/, (message) ->
    process.exit(0)
  
  j.watch_for /^!version/, (message) ->
    message.say "I'm running CoffeeScript v0"
).connect options
