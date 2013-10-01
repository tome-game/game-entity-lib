module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-coffee-coverage'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-browserify'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    browserify:
      package_deps:
        files:
          'lib/<%= pkg.name %>-with-deps.js': 'lib/<%= pkg.name %>.js'

    clean:
      build_files: ['build', 'lib/*', 'test/coverage.html']

    coffee:
      compile:
        'package':
          join: true
          separator: ';\n'
        files:
          'lib/<%= pkg.name %>.js': [
            'src/tome.coffee',
            'src/core/event.coffee',
            'src/core/event_source.coffee',
            'src/core/*.coffee',
            'src/utils/*.coffee',
            'src/components/*.coffee',
            'src/controllers/*.coffee'
          ]

    coffeeCoverage:
      options:
        exclude: ['src', 'test', 'lib']
      build: 'build'

    copy:
      source:
        files: [expand: true, cwd: 'src', src: '**', dest: 'build']

    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: ['coffee-script', 'test/test_helper.coffee']
        src: ['**/*_test.coffee']

      'html-cov':
        options:
          reporter: 'html-cov'
          quiet: true
          captureFile: 'test/coverage.html'
        src: ['test/**/*.coffee']

      'travis-cov':
        options:
          reporter: 'travis-cov'
        src: ['test/**/*.coffee']

  grunt.registerTask 'default', ['clean', 'compile', 'test']
  grunt.registerTask 'compile', ['coffee', 'copy', 'browserify']
  grunt.registerTask 'test', ['coffeeCoverage', 'mochaTest']

