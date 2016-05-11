var gulp       = require('gulp'),
    server     = require('gulp-server-livereload'),
    watch      = require('gulp-watch'),
    stylus     = require('gulp-stylus'),
    gulpJade   = require('gulp-jade'),
    jade       = require('jade'),
    livescript = require('gulp-livescript'),
    browserify = require('browserify'),
    buffer     = require('vinyl-buffer'),
    gutil      = require('gulp-util'),
    livereload = require('gulp-livereload'),
    merge      = require('merge'),
    rename     = require('gulp-rename'),
    sourcemaps = require('gulp-sourcemaps');

var paths = {
  ls: ['./src/**/*.ls'],
  jade: ['./src/**/*.jade']
};

gulp.task('default', function() {
  // place code for your default task here
});

gulp.task('ls', function() {
  return gulp.src(paths.ls)
  .pipe(sourcemaps.init())
  .pipe(livescript())
  .pipe(sourcemaps.write('./maps/'))
  .pipe(gulp.dest('./build/'));
});

gulp.task('jade', function() {
  gulp.src(paths.jade)
    .pipe(sourcemaps.init())
    .pipe(gulpJade({
      jade: jade,
      pretty: true
    }))
    .pipe(sourcemaps.write('./maps/'))
    .pipe(gulp.dest('./build/'))
});

gulp.task('watch', function () {
  gulp.watch(paths.ls, ['ls']);
  gulp.watch(paths.jade,['jade']);
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

gulp.task('serve', ['ls', 'jade', 'web-server']);





