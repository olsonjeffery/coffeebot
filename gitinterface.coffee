exec = require('child_process').exec

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

module.exports = {sha1Hash:sha1Hash, pullOnRepo:pullOnRepo}
