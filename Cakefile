# Cakefile to document, compile, join and minify CoffeeScript files for
# client side apps. Just edit the config object literal.
#
# -jrmoran

fs            = require 'fs'
{exec, spawn} = require 'child_process'

# order of files in `inFiles` is important
# TODO automate file inclusion
config =
  srcDir:  'coffee'
  outDir:  'js'
  inFiles: [ 'config', 'base64', 'controllers/manage', 'controllers/home', 'controllers/case', 'controllers/user', 'directives/vldt', 'directives/navigation', 'services', 'plugins' ]
  outFile: 'client'
  yuic:    'C:/Users/Simon/Development/Libraries/Java/yuicompressor-2.4.2.jar'

outJS    = "#{config.outDir}/#{config.outFile}"
strFiles = ("#{config.srcDir}/#{file}.coffee" for file in config.inFiles).join ' '

# deal with errors from child processes
exerr  = (err, sout, serr)->
  process.stdout.write err if err
  process.stdout.write sout if sout
  process.stdout.write serr if serr

# this will keep the non-minified compiled and joined file updated as files in
# `inFile` change.
task 'watch', 'watch and compile changes in source dir', ->
  watch = exec "coffee -j #{outJS}.js -cw #{strFiles}"
  watch.stdout.on 'data', (data)-> process.stdout.write data

task 'build', 'join and compile *.coffee files', ->
  exec "coffee -j #{outJS}.js -c #{strFiles}", exerr

#task 'build:vendor', 'join and compile *.js vendor files', ->
#  exec "coffee -j vendor.js -c js/vendor/*.js", exerr

task 'min', 'minify compiled *.js file', ->
  exec "java -jar #{config.yuic} #{outJS}.js -o #{outJS}.min.js", exerr

task 'bam', 'build and minify', ->
  invoke 'build'
  invoke 'min'

task 'test', 'runs jasmine tests', ->
  exec 'jasmine-node --coffee --verbose spec', exerr

# watch files and run tests automatically
task 'watch:test', 'watch and run tests', ->
  console.log 'watching...'

  whenChanged = (filename, fun)->
    fs.watchFile filename, (curr, prev)->
      fun() if curr.mtime > prev.mtime

  for f in config.inFiles
    whenChanged "#{f}.coffee", ->
      console.log "===== TEST #{new Date().toLocaleString()} ====="
      invoke 'test'