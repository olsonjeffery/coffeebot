spawn = require('child_process').spawn

git = require './gitinterface'

class CSNodePrint
  constructor: (@code, @coffeeBin, @gistBin) ->
  
  run: (cb) ->
    stdio = ''
    child = spawn @coffeeBin, ['-n', '-s']
    output = (d) -> stdio += if !!d then d else ''
    child.stdout.addListener 'data', output

    gistBin = @gistBin
    child.addListener 'exit', (errCode) -> 
      git.postGist stdio, gistBin, (gistUrl) -> 
        cb gistUrl
    child.stdin.write @code
    child.stdin.end()
module.exports = CSNodePrint
