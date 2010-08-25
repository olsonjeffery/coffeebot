sys = require 'sys'
Script = process.binding('evals').Script
options = require './options'
CS = require "#{options.csLocation}/lib/coffee-script"

stdin = process.openStdin()
code = ''

stdin.addListener 'data', (data) -> code += data

git = require './gitinterface'

run = ->
  process.stdout.addListener 'drain', ->
    process.exit 0
  if code == '__get_cs_version'
    git.sha1Hash options.csLocation, (csHash) ->
      git.sha1Hash options.nodeLocation, (nodeHash) ->
        versionInfo = "coffee v#{CS.VERSION} (#{csHash}), node.js #{process.version} (#{nodeHash})"
        process.stdout.write versionInfo
  else
    outputLog = []
    usedPuts = false
    sandbox = {}
    sandbox.puts = (d) -> outputLog.push d; usedPuts = true
    
    js = CS.compile code, noWrap: true
    output = Script.runInNewContext js, sandbox
    if usedPuts
      if outputLog.length > 10
        result = outputLog[outputLog.length-10..outputLog.length]
        result.unshift('More than 10 results, showing last ten.')
        outputLog = result
      if outputLog.join('\n').length > 512
        outputLog.unshift('Total output length greater than 512 characters. Truncating.')
        outputLog = (outputLog.join('\n')[0..508]+'...').split('\n')
      process.stdout.write outputLog.join("\n")
    else
      process.stdout.write sys.inspect(output)

stdin.addListener 'end', run
