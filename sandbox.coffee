spawn = require('child_process').spawn

class Sandbox
  constructor: (@code, @coffeeBin) ->
  
  run: (callbackFunc) ->
    doCallback = (cb, result) ->
      cb result
    
    try
      timer = null
      stdout = ''
      stderr = ''
      output = (data) ->
        stdout += if !!data then data else ''
      errOut = (data) ->
        stderr += if !!data then data else ''
      child = spawn @coffeeBin, ['runner.coffee']
      child.stdout.addListener 'data', output
      child.stderr.addListener 'data', errOut
      child.addListener 'exit', (exitCode) ->
        clearTimeout(timer)
        if stdout == ''
          stdout = stderr
        result = if stdout? then stdout else 'error. hm.'
        doCallback callbackFunc, result
      
      child.stdin.write @code
      child.stdin.end()
      
      timeoutCallback = ->
        child.stdout.removeListener 'output', output
        child.stderr.removeListener 'errOut', errOut

        stdout = "TimeoutError"
        child.kill()
      
      timer = setTimeout(timeoutCallback, 5000)
      
      
    catch e # error parsing the CS
      result = if e.stack? then e.split("\n")[0] else e.toString()    
      doCallback callbackFunc, result

module.exports = Sandbox
