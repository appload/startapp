sys = require 'sys'
{spawn} = require 'child_process'

task 'watch', 'Watch src directory and build to lib', ->
  coffee = spawn 'coffee', ['--lint', '--output', 'lib', '--watch', 'src']
  coffee.stdout.on 'data', (data) ->
    sys.print data.toString()
  coffee.stderr.on 'data', (data) ->
    sys.print data.toString()