gutil      = require 'gulp-util'
connect    = require 'gulp-connect'
gulpif     = require 'gulp-if'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
tplCache   = require 'gulp-angular-templatecache'
jade       = require 'gulp-jade'
less       = require 'gulp-less'
sourcemaps = require 'gulp-sourcemaps'
ngClassify = require 'gulp-ng-classify'
coffeelint = require 'gulp-coffeelint'
rimraf     = require 'gulp-rimraf'
uglify     = require 'gulp-uglify'
minifyCSS  = require 'gulp-minify-css'
runSequence = require 'run-sequence'

base = require './gulpfile.coffee'
gulp = base.gulp
ngClassifyDefinitions = require('./gulpfile_commons.coffee').ngClassifyDefinitions

base.destDir = './browse/'

base.paths.libJs = [
  './bower_components/angular/angular.min.js'
  './bower_components/angular-ui-router/release/angular-ui-router.min.js'
  './bower_components/angular-animate/angular-animate.min.js'
  './bower_components/angular-translate/angular-translate.min.js'
  './bower_components/angular-svg-round-progressbar/roundProgress.js'
  './bower_components/angular-bootstrap/ui-bootstrap-tpls.js'
  './bower_components/underscore/underscore-min.js'
  './bower_components/angular-utf8-base64/angular-utf8-base64.min.js'
]

base.paths.libCss = [
  './app/css/bootstrap.min.css'
  './bower_components/font-awesome/css/font-awesome.min.css'
]

gulp.task 'browse_clean', ['clean'], ->
  gulp.src ['browse/']
  .pipe rimraf
    read: false
    force: true

gulp.task 'appJs',  ->
  gulp.src base.paths.appJs #tutte le sottocartelle di app con file .coffee o .js
  .pipe coffeelint().on 'error', gutil.log
  .pipe ngClassify(ngClassifyDefinitions) .on 'error', gutil.log
  .pipe coffeelint.reporter().on 'error', gutil.log
  .pipe sourcemaps.init().on 'error', gutil.log
  .pipe (gulpif /[.]coffee$/, coffee(bare: true).on 'error', gutil.log).on 'error', gutil.log
  .pipe concat('app.js').on 'error', gutil.log
  .pipe uglify({"mangle":false})
  .pipe sourcemaps.write('./maps').on 'error', gutil.log
  .pipe gulp.dest(base.destDir + 'js').on 'error', gutil.log

gulp.task 'appCss', ->
  gulp.src base.paths.appCss
  .pipe gulpif /[.]less$/, less
    paths: []
  .on 'error', gutil.log
  .pipe concat 'style.css'
  .pipe minifyCSS()
  .pipe gulp.dest base.destDir + 'css'

gulp.task 'default', ->
  runSequence 'browse_clean', 
  [
    'appJs',
    'libJs',
    'minMaps',
    'index',
    'templates',
    'appCss',
    'libCss',
    'img',
    'favicon',
    'fonts',
    'libMap',
    'connect',
  ]