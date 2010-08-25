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
        git.sha1Hash process.cwd(), (cbHash) ->
          versionInfo = "coffeebot #{cbHash}, running coffee v#{CS.VERSION} (#{csHash}), node.js #{process.version} (#{nodeHash})"
          process.stdout.write versionInfo
  else
    outputLog = []
    usedPuts = false
    sandbox = {}
    sandbox.puts = (d) -> outputLog.push d; usedPuts = true
    
    js = CS.compile code, noWrap: true
    output = Script.runInNewContext js, sandbox
    if usedPuts
      if outputLog.length > 1 or outputLog.join("\n").length > 512
        git.postGist(outputLog.join("\n"), options.gistBin, (o) -> process.stdout.write(o))
      else
        process.stdout.write outputLog.join("\n")
    else
      process.stdout.write sys.inspect(output)

stdin.addListener 'end', run
