var gulp        = require('gulp'),
server          = require('gulp-server-livereload'),
watch           = require('gulp-watch'),
stylus          = require('gulp-stylus'),
gulpJade        = require('gulp-jade'),
jade            = require('jade'),
livescript      = require('gulp-livescript'),
livereload      = require('gulp-livereload'),
sourcemaps      = require('gulp-sourcemaps'),
angularFilesort = require('gulp-angular-filesort'),
inject          = require('gulp-inject'),
wiredep         = require('wiredep').stream,
usemin          = require('gulp-usemin'),
minifyCss       = require('gulp-clean-css'),
concat          = require('gulp-concat'),
concatCss       = require('gulp-concat-css'),
uglify          = require('gulp-uglify'),
rev             = require('gulp-rev'),
minifyHtml      = require('gulp-htmlmin'),
clean           = require('gulp-clean'),
copy            = require('gulp-copy'),
gutil           = require('gulp-util'),
vinylPaths      = require('vinyl-paths'),
debug           = require('gulp-debug'),
tap             = require('gulp-tap'),
fs              = require('fs'),
minifyHtmlInput = require('html-minifier').minify,
escape          = require('js-string-escape');

var paths = {
  ls: ['./src/**/*.ls', './src/lib/**/*.ls'],
  jade: ['./src/**/*.jade'],
  stylus: ['./src/**/*.styl'],
  js: ['./build/app/**/*.js'],
  html: ['app/**/*.html'],
  css: ['assets/**/*.css', 'app/**/*.css'],
  maps: '.',
  bower_dir: './build/lib/',
  bower_files: './build/lib/**/*.*',
  inject_js: ['!**/app.**.js', 'app/**/*.js'],
  inject_css: ['assets/**/*.css', 'app/**/*.css'],
  src_vendor_files: ['!./src/vendor/**/*.ls', './src/vendor/**/*.*'],
  vendor_files: ['!vendor/prelude-ls/*', 'vendor/**/*.js', 'vendor/**/*.css'],
  directives: ['./build/app/**/*Directive.js']
};

gulp.task('default', function() {
  // place code for your default task here
  });

gulp.task('copy-lib', function () {
  return gulp.src(paths.src_vendor_files)
  .pipe(copy('./build/vendor/'));
  });

gulp.task('inject-templates', ['ls', 'jade'], function () {
    return gulp.src(paths.directives)
  .pipe(inject(
    gulp.src(paths.html, {'cwd': __dirname + '/build'}),
    {
      // addRootSlash: false,
      relative: true,
      starttag: 'template: \'',
      endtag: '\'',
      transform: function (filePath, file, i, length, targetFile) {
        if (filePath.indexOf('/') === -1) {
          // console.log(', template: \"' + file.contents.toString('utf-8') + '\"');
          return escape(minifyHtmlInput(file.contents.toString('utf-8'), {collapseWhitespace: true, preventAttributesEscaping: true}));
        }
      }
    }
    )).pipe(gulp.dest('./build/app/'));
});

gulp.task('vendor', ['ls', 'jade'], function () {
  return gulp.src('./build/index.html')
  .pipe(inject(
    gulp.src(paths.vendor_files, {'cwd': __dirname + '/build', 'read': false}),
    {
      addRootSlash: false,
      starttag: '<!-- inject:vendor:{{ext}}-->'
    }
    )).pipe(gulp.dest('./build'));
  });

gulp.task('injection', ['ls', 'stylus', 'jade', 'vendor'], function(){
  return gulp.src('./build/index.html')
  .pipe(inject(
    gulp.src(paths.inject_js, {'cwd': __dirname + '/build'})
    .pipe(angularFilesort()),
    { addRootSlash: false }
    ))
  .pipe(inject(
    gulp.src(paths.inject_css, {'cwd': __dirname + '/build'}), { addRootSlash: false }))
  .pipe(gulp.dest('./build'));
  });

gulp.task('wiredep', ['injection'], function(){
  return gulp.src('./build/index.html')
  .pipe(wiredep({
    directory: paths.bower_dir,
    devDependencies: true
    }))
  .pipe(gulp.dest('./build'));
  });

gulp.task('clean_dist', ['builder'], function () {
  return gulp.src('dist/', {read: false})
  .pipe(clean());
  });

gulp.task('ls', function() {
  return gulp.src(paths.ls)
  .pipe(sourcemaps.init())
  .pipe(livescript())
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'));
  });

gulp.task('jade', function() {
  return gulp.src(paths.jade)
  .pipe(sourcemaps.init())
  .pipe(gulpJade({
    jade: jade,
    pretty: true
    }))
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'))
  });

gulp.task('stylus', function () {
  return gulp.src(paths.stylus)
  .pipe(sourcemaps.init())
  .pipe(stylus())
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'));
  });

gulp.task('watch', ['builder'], function () {
  gulp.watch(paths.src_vendor_files, ['vendor']);
  gulp.watch(paths.ls, ['inject-templates', 'injection', 'wiredep']);
  gulp.watch(paths.jade, ['inject-templates', 'injection', 'wiredep']);
  gulp.watch(paths.bower_files, ['wiredep']);
  });

gulp.task('usemin', ['clean_dist'], function() {
  return gulp.src('./build/index.html')
  .pipe(usemin({
    css: [ minifyCss(), rev() ],
    html: [ minifyHtml({collapseWhitespace: true}) ],
    js: [ uglify({beautify: true, mangle: false}), rev() ],
    inlinejs: [ uglify({beautify:true, mangle: true}) ],
    inlinecss: [ minifyCss() ]
    }))
  .pipe(gulp.dest('./dist/'));
  });

gulp.task('serve', ['watch'], function () {
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

gulp.task('builder', ['inject-templates', 'stylus', 'vendor', 'injection', 'wiredep']);
gulp.task('dist', ['usemin']);





