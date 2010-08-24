sys = require 'sys'
Script = process.binding('evals').Script

CS = require '../coffee-script/lib/coffee-script'

stdin = process.openStdin()
code = ''

stdin.addListener 'data', (data) ->
  code += data

sandbox = {}
run = ->
  js = CS.compile code, noWrap: true
  output = Script.runInNewContext js, sandbox
  process.stdout.addListener 'drain', ->
    process.exit 0
  process.stdout.write(sys.inspect(output))

stdin.addListener 'end', run
