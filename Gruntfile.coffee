module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Updating the package manifest files
    noflo_manifest:
      update:
        files:
          'component.json': ['graphs/*', 'components/*']
          'package.json': ['graphs/*', 'components/*']

    # Browser build of NoFlo
    noflo_browser:
      build:
        files:
          'browser/redis.js': ['component.json']

    # Coding standards
    coffeelint:
      components:
        files:
          src: ['components/*.coffee']
        options:
          max_line_length:
            value: 80
            level: 'warn'

    nodeunit:
      all: ['test/*.coffee']

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-noflo-manifest'
  @loadNpmTasks 'grunt-noflo-browser'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-coffeelint'
  @loadNpmTasks 'grunt-contrib-nodeunit'

  # Our local tasks
  @registerTask 'build', 'Build NoFlo for the chosen target platform', (target = 'all') =>
    @task.run 'noflo_manifest'
    if target is 'all' or target is 'browser'
      @task.run 'noflo_browser'

  @registerTask 'test', 'Build NoFlo and run automated tests', (target = 'all') =>
    @task.run 'coffeelint'
    @task.run 'noflo_manifest'
    if target is 'all' or target is 'nodejs'
      @task.run 'nodeunit'
    if target is 'all' or target is 'browser'
      @task.run 'noflo_browser'

  @registerTask 'default', ['test']
