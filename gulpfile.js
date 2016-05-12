var gulp            = require('gulp'),
    server          = require('gulp-server-livereload'),
    watch           = require('gulp-watch'),
    stylus          = require('gulp-stylus'),
    gulpJade        = require('gulp-jade'),
    jade            = require('jade'),
    livescript      = require('gulp-livescript'),
    browserify      = require('browserify'),
    buffer          = require('vinyl-buffer'),
    gutil           = require('gulp-util'),
    livereload      = require('gulp-livereload'),
    merge           = require('merge'),
    rename          = require('gulp-rename'),
    sourcemaps      = require('gulp-sourcemaps'),
    angularFilesort = require('gulp-angular-filesort'),
    inject          = require('gulp-inject'),
    wiredep         = require('wiredep').stream,
    usemin          = require('gulp-usemin'),
    minifyCss        = require('gulp-clean-css'),
    concat          = require('gulp-concat'),
    concatCss       = require('gulp-concat-css'),
    uglify          = require('gulp-uglify'),
    rev             = require('gulp-rev'),
    minifyHtml      = require('gulp-htmlmin');

var paths = {
  ls: ['./src/**/*.ls'],
  jade: ['./src/**/*.jade'],
  js: ['./build/**/*.js'],
  maps: '.',
  bower: './bower_components/**/*.*'
};

gulp.task('default', function() {
  // place code for your default task here
});

gulp.task('injection', function(){

  gulp.src('./build/index.html')
  .pipe(inject(
        gulp.src(['**/*.js'], {'cwd': __dirname + '/build'}) // gulp-angular-filesort depends on file contents, so don't use {read: false} here
        .pipe(angularFilesort()),
        { addRootSlash: false }
        ))
  .pipe(gulp.dest('./build'));
});

gulp.task('wiredep', function(){
  gulp.src('./build/index.html')
  .pipe(wiredep({
    directory: './bower_components',
    devDependencies: true
  }))
  .pipe(gulp.dest('./build'));
});

gulp.task('ls', function() {
  return gulp.src(paths.ls)
  .pipe(sourcemaps.init())
  .pipe(livescript())
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'));
});

gulp.task('jade', function() {
  gulp.src(paths.jade)
    .pipe(sourcemaps.init())
    .pipe(gulpJade({
      jade: jade,
      pretty: true
    }))
    .pipe(sourcemaps.write(paths.maps))
    .pipe(gulp.dest('./build/'))
});

gulp.task('watch', function () {
  gulp.watch(paths.ls, ['ls']);
  gulp.watch(paths.jade, ['jade', 'injection']);
  gulp.watch(paths.bower, ['wiredep']);
});

gulp.task('usemin', function() {
  return gulp.src('./build/**/*.html')
    .pipe(usemin({
      css: [ rev() ],
      html: [ minifyHtml({ empty: true }) ],
      js: [ uglify(), rev() ],
      inlinejs: [ uglify() ],
      inlinecss: [ minifyCss() ]
    }))
    .pipe(gulp.dest('./dist/'));
});

gulp.task('web-server', ['watch'], function () {
  gulp.src('./build/')
    .pipe(server({
      livereload: {
        enable: true,
        filter: function (filename, cb) {
          cb(!/\.ls$|\.jade$|node_modules/.test(filename));
        }
      },
      directoryListing: false,
      open: true
    }));
});

gulp.task('serve', ['ls', 'jade', 'injection', 'web-server']);
gulp.task('dist', ['usemin']);





