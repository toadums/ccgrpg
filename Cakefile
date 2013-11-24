
fs            = require 'fs'
{exec, spawn} = require 'child_process'

# order of files in `inFiles` is important
config =
  srcDir:  'client/app/coffeescripts/'
  outDir:  'client/public/javascripts'
  inFiles: [
    'models/card'
    'models/cards'
    'viewModels/cardViewModel'
    'viewModels/roomViewModel'
    'models/player'
    'server'
    'main'
    'customBindings'
  ]
  outFile: 'app'
  yuic:    'yuicompressor'

outJS    = "#{config.outDir}/#{config.outFile}"
strFiles = ("#{config.srcDir}/#{file}.coffee" for file in config.inFiles).join ' '

# deal with errors from child processes
exerr  = (err, sout,  serr)->
  process.stdout.write err  if err
  process.stdout.write sout if sout
  process.stdout.write serr if serr

# this will keep the non-minified compiled and joined file updated as files in
# `inFile` change.
task 'watch', 'watch and compile changes in source dir', ->
  serv  = exec "coffee -w server/lib/server.coffee"
  watch = exec "coffee -j #{outJS}.js -cwb #{strFiles}"
  sass  = exec "sass --watch client/app/sass:client/public/stylesheets"

  serv.stdout.on 'data', (data)-> process.stdout.write data
  watch.stdout.on 'data', (data)-> process.stdout.write data
  sass.stdout.on 'data', (data)-> process.stdout.write data

  serv.stderr.on 'data', (data)-> process.stderr.write data
  watch.stderr.on 'data', (data)-> process.stderr.write data
  sass.stderr.on 'data', (data)-> process.stderr.write data