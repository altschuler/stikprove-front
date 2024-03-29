// Generated by CoffeeScript 1.4.0
(function() {
  var config, exec, exerr, file, fs, outJS, spawn, strFiles, _ref;

  fs = require('fs');

  _ref = require('child_process'), exec = _ref.exec, spawn = _ref.spawn;

  config = {
    srcDir: 'coffee',
    outDir: 'js',
    inFiles: ['config', 'base64', 'controllers/manage', 'controllers/home', 'controllers/case', 'directives/vldt', 'directives/navigation', 'services', 'plugins'],
    outFile: 'client',
    yuic: 'C:/Users/Simon/Development/Libraries/Java/yuicompressor-2.4.2.jar'
  };

  outJS = "" + config.outDir + "/" + config.outFile;

  strFiles = ((function() {
    var _i, _len, _ref1, _results;
    _ref1 = config.inFiles;
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      file = _ref1[_i];
      _results.push("" + config.srcDir + "/" + file + ".coffee");
    }
    return _results;
  })()).join(' ');

  exerr = function(err, sout, serr) {
    if (err) {
      process.stdout.write(err);
    }
    if (sout) {
      process.stdout.write(sout);
    }
    if (serr) {
      return process.stdout.write(serr);
    }
  };

  task('watch', 'watch and compile changes in source dir', function() {
    var watch;
    watch = exec("coffee -j " + outJS + ".js -cw " + strFiles);
    return watch.stdout.on('data', function(data) {
      return process.stdout.write(data);
    });
  });

  task('build', 'join and compile *.coffee files', function() {
    return exec("coffee -j " + outJS + ".js -c " + strFiles, exerr);
  });

  task('min', 'minify compiled *.js file', function() {
    return exec("java -jar " + config.yuic + " " + outJS + ".js -o " + outJS + ".min.js", exerr);
  });

  task('bam', 'build and minify', function() {
    invoke('build');
    return invoke('min');
  });

  task('test', 'runs jasmine tests', function() {
    return exec('jasmine-node --coffee --verbose spec', exerr);
  });

  task('watch:test', 'watch and run tests', function() {
    var f, whenChanged, _i, _len, _ref1, _results;
    console.log('watching...');
    whenChanged = function(filename, fun) {
      return fs.watchFile(filename, function(curr, prev) {
        if (curr.mtime > prev.mtime) {
          return fun();
        }
      });
    };
    _ref1 = config.inFiles;
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      f = _ref1[_i];
      _results.push(whenChanged("" + f + ".coffee", function() {
        console.log("===== TEST " + (new Date().toLocaleString()) + " =====");
        return invoke('test');
      }));
    }
    return _results;
  });

}).call(this);
