sys = require 'sys'
Script = process.binding('evals').Script
options = require './options'
CS = require "#{options.csLocation}/lib/coffee-script"

stdin = process.openStdin()
code = ''

stdin.addListener 'data', (data) ->
  code += data

run = ->
  console = []
  usedPuts = false
  sandbox = {}
  sandbox.puts = (d) -> console.push d; usedPuts = true
  
  process.stdout.addListener 'drain', ->
    process.exit 0
  if code == '__get_cs_version'
    versionInfo = "coffee v#{CS.VERSION}, node.js #{process.version}"
    process.stdout.write versionInfo
  else
    js = CS.compile code, noWrap: true
    output = Script.runInNewContext js, sandbox
    if usedPuts
      if console.length > 10
        result = console[console.length-10..console.length]
        result.unshift('More than 10 results, showing last ten.')
        console = result
      process.stdout.write console.join("\n")
    else
      process.stdout.write sys.inspect(output)

stdin.addListener 'end', run
