# Generated on <%= (new Date).toISOString().split('T')[0] %> using <%= pkg.name %> <%= pkg.version %>
'use strict'
nconf = require 'nconf'
path = require 'path'
LIVERELOAD_PORT = 35729
lrSnippet = require('connect-livereload') port: LIVERELOAD_PORT
mountFolder = (connect, dir) ->
    connect.static require('path').resolve(dir)

getWebDavTarget = () ->
    nconf.env().file({'file':'.webdavconf.json'} )
    root = nconf.get('<%=webDavProperty%>')
    path.join root, '/_catalogs/masterpage/'
# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  yeomanConfig =
    app: 'app'
    dist: 'dist',
    tmp: '.tmp',
    master: '<%= masterSlug %>',
    targetWebDav: getWebDavTarget()
  for dirKey in ['app', 'dist', 'tmp']
    yeomanConfig["#{dirKey}Master"] = yeomanConfig[dirKey] + '/' + yeomanConfig.master

  grunt.initConfig
    yeoman: yeomanConfig

    # Dev Utility

    watch:
      options:
        nospawn: false
        liverleoad: true
      gruntfile:
        files: ['Gruntfile.{js,coffee}']
      coffee:
        files: ['<%%= yeoman.app %>/scripts/{,*/}*.coffee']
        tasks: ['coffee:dist']
      coffeeTest:
        files: ['test/spec/{,*/}*.coffee']
        tasks: ['coffee:test']
      compass:
        files: ['<%%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass:server'<% if (autoprefixer) { %>, 'autoprefixer' <% } %> ]
       <% if (autoprefixer) { %>
      styles:
        files: ['<%%= yeoman.app %>/styles/{,*/}*.css']
        tasks: ['copy:styles', 'autoprefixer']
       <% } %>
      jade:
        files: ['app/jade/{,*/}*.jade']
        tasks: ['jade']
      livereload:
        options:
          livereload: LIVERELOAD_PORT
        files: [
          '{<%%= yeoman.tmp %>,<%%= yeoman.app %>}/*.html',
          '{<%%= yeoman.tmpMaster %>,<%%= yeoman.app %>}/styles/{,*/}*.css',
          '{<%%= yeoman.tmpMaster %>,<%%= yeoman.app %>}/scripts/{,*/}*.js',
          '{<%%= yeoman.tmpMaster %>,<%%= yeoman.app %>}/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]

    connect:
      options:
        port: 9000
        hostname: 'localhost' # change this to '0.0.0.0' to access the server from outside
      livereload:
        options:
          middleware: (connect) -> [
            lrSnippet
            mountFolder connect, yeomanConfig.tmp
            mountFolder connect, yeomanConfig.app
          ]
      test:
        options:
          middleware: (connect) -> [
            mountFolder connect, yeomanConfig.tmp
            mountFolder connect, 'test'
          ]
      dist:
        options:
          middleware: (connect) -> [
            mountFolder connect, yeomanConfig.dist
          ]

    jshint:
      options:
        jshintrc: '.jshintrc'
      all: [
        '<%%= yeoman.app %>/scripts/{,*/}*.js'
        '!<%%= yeoman.app %>/scripts/vendor/*'
        'test/spec/{,*/}*.js'
      ]

     <% if (testFramework === 'mocha') { %>
    mocha:
      all:
        options:
          run: true
          urls: ['http://localhost:<%%= connect.options.port %>/index.html']
     <% } else if (testFramework === 'jasmin') { %>
    jasmine:
      all:
        options:
          specs: 'test/spec/{,*/}*.js'
     <% } %>
    preview:
      html:
        files: [
          cwd: '.tmp'
          src: '*.html'
          dest: "http://localhost:<%%= connect.options.port %>/"
        ,
          cwd: 'app'
          src: '*.html'
          dest: "http://localhost:<%%= connect.options.port %>/"
        ]

    # Template compilers

    coffee:
      dist:
        files: [
          expand: true
          cwd: '<%%= yeoman.app %>/scripts'
          src: '{,*/}*.coffee'
          dest: '<%%= yeoman.tmpMaster %>/scripts'
          ext: '.js'
        ]
      test:
        files: [
          expand: true
          cwd: 'test/spec'
          src: '{,*/}*.coffee'
          dest: '.tmp/spec'
          ext: '.js'
        ]

    jade:
      html:
        src: [
          'app/jade/**/*.jade'
          '!app/jade/**/_*.jade'
        ]
        dest: '.tmp',
        options:
          client: false
          basePath: '<%%= yeoman.app %>/jade'
          pretty: true
          locals:
            masterPath: '<%%= yeoman.master %>'
            imagePath: '<%%= yeoman.master %>/images'
            stylePath: '<%%= yeoman.master %>/styles'
            scriptPath: '<%%= yeoman.master %>/scripts'

    compass:
      options:
        sassDir: '<%%= yeoman.app %>/styles'
        cssDir: '<%%= yeoman.tmpMaster %>/styles'
        generatedImagesDir: '<%%= yeoman.tmpMaster %>/images/generated'
        imagesDir: '<%%= yeoman.app %>/images'
        javascriptsDir: '<%%= yeoman.app %>/scripts'
        fontsDir: '<%%= yeoman.app %>/styles/fonts'
        importPath: '<%%= yeoman.app %>/bower_components'
        httpImagesPath: '../images'
        httpGeneratedImagesPath: '../images/generated'
        httpFontsPath: '../styles/fonts'
        relativeAssets: false
      dist: { }
      server:
        options:
          debugInfo: true

     <% if (autoprefixer) { %>
    autoprefixer:
      options:
        browsers: ['last 1 version']
      dist:
        files: [
          expand: true
          cwd: '<%%= yeoman.tmpMaster %>/styles/'
          src: '{,*/}*.css'
          dest: '<%%= yeoman.tmpMaster %>/styles/'
        ]
     <% } %>

    # Minify assets

    # not used since Uglify task does concat,
    # but still available if needed
    ###
    concat:
      dist: { }
    ###
    # not enabled since usemin task does concat and uglify
    # check index.html to edit your build targets
    # enable this task if you prefer defining your build targets here
    ###
    uglify:
      dist: { }
    ###

    rev:
      dist:
        files:
          src: [
            '<%%= yeoman.distMaster %>/scripts/{,*/}*.js'
            '<%%= yeoman.distMaster %>/styles/{,*/}*.css'
            '<%%= yeoman.distMaster %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}'
            '<%%= yeoman.distMaster %>/styles/fonts/*'
            '!<%%= yeoman.distMaster %>/images/touch-icon*.png' # apple touch icons
            '!<%%= yeoman.distMaster %>/images/generated/*.png' # generated images are rev'ed by compass
          ]

    useminPrepare:
      options:
        dest: '<%%= yeoman.dist %>'
      html: [
        '<%%= yeoman.tmp %>/*.html'
        '<%%= yeoman.app %>/*.html'
      ]

    usemin:
      options:
        dirs: ['<%%= yeoman.dist %>']
      html: ['<%%= yeoman.dist %>/{,*/}*.html']
      css: ['<%%= yeoman.distMaster %>/styles/{,*/}*.css']

    imagemin:
      dist:
        files: [
          expand: true
          cwd: '<%%= yeoman.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg}'
          dest: '<%%= yeoman.distMaster %>/images'
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: '<%%= yeoman.app %>/images'
          src: '{,*/}*.svg'
          dest: '<%%= yeoman.distMaster %>/images'
        ]

    cssmin:
      dist:
        files:
          '<%%= yeoman.distMaster %>/styles/main.css': [
            '<%%= yeoman.tmpMaster %>/styles/{,*/}*.css'
            '<%%= yeoman.app %>/styles/{,*/}*.css'
          ]

    htmlmin:
      dist:
        options: {
          ###
          removeCommentsFromCDATA: true
          # https://github.com/yeoman/grunt-usemin/issues/44
          # collapseWhitespace: true
          collapseBooleanAttributes: true
          removeAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true
          removeEmptyAttributes: true
          removeOptionalTags: true
          ###
        }
        files: [
          expand: true
          cwd: '<%%= yeoman.app %>'
          src: '*.html'
          dest: '<%%= yeoman.dist %>'
        ,
          expand: true
          cwd: '<%%= yeoman.tmp %>'
          src: '*.html'
          dest: '<%%= yeoman.dist %>'
        ]

    # Framework stuff

    bower:
      options:
        exclude: ['modernizr']

    clean:
      dist:
        files: [
          dot: true
          src: [
            '<%%= yeoman.tmp %>'
            '<%%= yeoman.dist %>/*'
            '!<%%= yeoman.dist %>/.git*'
          ]
        ]
      server: '<%%= yeoman.tmp %>'

    # Put files not processed by other tasks here
    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: '<%%= yeoman.app %>'
          dest: '<%%= yeoman.dist %>'
          src: 'images/{,*/}*.{ico,webp,gif}' # not handled by imagemin
        ,
          expand: true,
          cwd: '<%%= yeoman.tmpMaster %>/images',
          dest: '<%%= yeoman.distMaster %>/images',
          src: 'generated/*.png' # compass generated images
        ,
          expand: true,
          cwd: '<%%= yeoman.app %>/fonts',
          dest: '<%%= yeoman.distMaster %>/fonts',
          src: '{,*/}*.*' # all fonts
        ]
       <% if (autoprefixer) { %>
      styles:
        expand: true
        dot: true
        cwd: '<%%= yeoman.app %>/styles'
        dest: '<%%= yeoman.tmpMaster %>/styles/'
        src: '{,*/}*.css'
       <% } %>
       <% if (webDavProperty) { %>
      deploy:
        files: [
          expand: true
          dot: false
          cwd: '<%%= yeoman.dist %>'
          dest: '<%%= yeoman.targetWebDav %>'
          src: ['*.html', '<%%= yeoman.master %>/**/*.*']
        ]
       <% } %>
    concurrent:
      server: [
        'jade'
        'compass:server'
        'coffee:dist'
         <% if (autoprefixer) { %>
        'copy:styles'
        'autoprefixer'
         <% } %>
      ]
      test: [
        'coffee'
         <% if (autoprefixer) { %>
        'copy:styles'
        'autoprefixer'
         <% } %>
      ]
      dist: [
        'coffee'
        'compass'
         <% if (autoprefixer) { %>
        'copy:styles'
         <% } %>
        'imagemin'
        'svgmin'
        'htmlmin'
      ]

    grunt.registerTask 'server', (target) ->
      return grunt.task.run ['build', 'preview', 'connect:dist:keepalive'] if target === 'dist'
      grunt.task.run [
        'clean:server'
        'concurrent:server'
         <% if (autoprefixer) { %>
        'autoprefixer'
         <% } %>
        'connect:livereload'
        'preview'
        'watch'
      ]

    grunt.registerTask 'test', [
      'clean:server'
      'concurrent:test'
       <% if (autoprefixer) { %>
      'autoprefixer'
       <% } %>
      'connect:test'
       <% if (testFramework === 'mocha') { %>
      'mocha'
       <% } else if (testFramework === 'jasmine') { %>
      'jasmine'
       <% } %>
    ]

    grunt.registerTask 'build', [
      'clean:dist'
      'jade'
      'useminPrepare'
      'concurrent:dist'
       <% if (autoprefixer) { %>
      'autoprefixer'
       <% } %>
       <% if (includeRequireJS) { %>
      'requirejs'
       <% } %>
      'cssmin'
      'concat'
      'uglify'
      'copy:dist'
      'rev'
      'usemin'
    ]

    grunt.registerTask 'default', [
      'jshint'
      'test'
      'build'
    ]
     <% if (webDavProperty) { %>
    grunt.registerTask 'deploy', [
      'default'
      'copy:deploy'
    ]
     <% } %>
