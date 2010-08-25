exec = require('child_process').exec
spawn = require('child_process').spawn

sha1Hash = (path, cb) ->
  curr = process.cwd()
  process.chdir path
  bleh = ''
  exec 'git log -1', (er, o, e) -> 
    process.chdir curr
    sha1 = o.split('\n')[0].replace('commit ', '')[0..7]
    cb sha1

pullOnRepo = (path, cb) ->
  curr = process.cwd()
  process.chdir path
  exec 'git pull', (er, o, e) ->
    process.chdir curr
    sha1Hash path, (sha1) ->
      cb sha1

postGist = (code, gistBin, cb) ->
  stdout = ''  
  output = (d) -> stdout += if !!d then d else ''
  child = spawn gistBin
  child.stdout.addListener 'data', output
  child.addListener 'exit', (exitCode) ->
    cb stdout
  child.stdin.write code
  child.stdin.end()

module.exports = {sha1Hash:sha1Hash, pullOnRepo:pullOnRepo, postGist:postGist}
