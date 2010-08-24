sys = require('sys')
Script = process.binding('evals').Script

stdin = process.openStdin()
code = ''

stdin.addListener 'data', (data) ->
  code += data

sandbox = {}
run = ->
  output = Script.runInNewContext code, sandbox
  process.stdout.addListener 'drain', ->
    process.exit 0
  process.stdout.write(sys.inspect(output))

stdin.addListener 'end', run
