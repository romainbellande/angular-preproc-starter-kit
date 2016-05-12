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
    usemin          = require('gulp-usemin-reloaded'),
    cleanCSS        = require('gulp-clean-css'),
    concat          = require('gulp-concat'),
    concatCSS       = require('gulp-concat-css');

var paths = {
  ls: ['./src/**/*.ls'],
  jade: ['./src/**/*.jade'],
  js: ['./build/**/*.js'],
  maps: '.'
};

gulp.task('default', function() {
  // place code for your default task here
});

gulp.task('injection', function(){

  gulp.src('./build/index.html')
  .pipe(wiredep({
    directory: './bower_components',
    devDependencies: true
  }))
  .pipe(inject(
        gulp.src(['**/*.js'], {'cwd': __dirname + '/build'}) // gulp-angular-filesort depends on file contents, so don't use {read: false} here
        .pipe(angularFilesort()),
        { addRootSlash: false }
        ))
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
  gulp.watch(paths.jade,['jade']);
});

gulp.task('usemin', function () {
  gulp.src('build/**/*.js')
    .pipe(
      usemin({
        rules: {
          build: {
            css: [cleanCSS(), concatCSS('bundle.css')],
            js: [uglify(), rev()],
            html: [minifyHtml({empty: true})],
            remove: function( object, content ) {
                return '';
            }
          }
        }
      })
    )
    .pipe(gulp.dest('./dist/'))
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





