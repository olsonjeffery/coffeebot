sys = require 'sys'
Script = process.binding('evals').Script
options = require './options'
CS = require "#{options.csLocation}/lib/coffee-script"

stdin = process.openStdin()
code = ''

stdin.addListener 'data', (data) ->
  code += data

sandbox = {}
run = ->
  process.stdout.addListener 'drain', ->
    process.exit 0
  if code == '__get_cs_version'
    versionInfo = "coffee v#{CS.VERSION}, node.js #{process.version}"
    process.stdout.write versionInfo
  else
    js = CS.compile code, noWrap: true
    output = Script.runInNewContext js, sandbox
    process.stdout.write(sys.inspect(output))

stdin.addListener 'end', run
