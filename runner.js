(function() {
  var Script, code, run, sandbox, stdin, sys;
  sys = require('sys');
  Script = process.binding('evals').Script;
  stdin = process.openStdin();
  code = '';
  stdin.addListener('data', function(data) {
    return code += data;
  });
  sandbox = {};
  run = function() {
    var output;
    output = Script.runInNewContext(code, sandbox);
    process.stdout.addListener('drain', function() {
      return process.exit(0);
    });
    return process.stdout.write(sys.inspect(output));
  };
  stdin.addListener('end', run);
})();
