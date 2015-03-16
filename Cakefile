ncp = require 'ncp'
{spawn, exec} = require 'child_process'
task 'build', 'Build project from src/*.coffee to public/*.js', ->
  exec 'coffee --compile --output public/js src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  ncp 'src/symbolTable', 'public/js/symbolTable', (err) ->
    throw err if err

task 'watch', 'continously build with --watch', ->
  coffee = spawn 'coffee', ['-cw', '-o', 'public/js', 'src']
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()