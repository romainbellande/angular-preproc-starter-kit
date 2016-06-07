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
escape          = require('js-string-escape'),
dogen           = require('gulp-dogen'),
nodemon         = require('gulp-nodemon'),
notify          = require('gulp-notify'),
browserSync    = require('browser-sync');

var reload = browserSync.reload;

var paths = {
  ls: ['!./src/server/node_modules', './src/**/*.ls', './src/client/lib/**/*.ls'],
  jade: ['!./src/server/node_modules', './src/**/*.jade'],
  stylus: ['!./src/server/node_modules', './src/**/*.styl'],
  js: ['./build/client/app/**/*.js'],
  html: ['app/**/*.html'],
  css: ['client/assets/**/*.css', 'client/app/**/*.css'],
  yml: ['!./src/server/node_modules','src/client/app/**/*.yml'],
  maps: '.',
  bower_dir: './build/client/lib/',
  bower_files: './build/client/lib/**/*.*',
  inject_js: ['!**/app.**.js', 'app/**/*.js'],
  inject_css: ['assets/**/*.css', 'app/**/*.css'],
  src_vendor_files: ['!./src/client/vendor/**/*.ls', './src/client/vendor/**/*.*'],
  vendor_files: ['!vendor/prelude-ls/*', 'vendor/**/*.js', 'vendor/**/*.css'],
  directives: ['./build/app/**/*Directive.js'],
  server_package: 'server/package.json',
  server: './build/server/bin/server.js',
  client: './build/client/index.html'
};

/*==============================
=            CLIENT            =
==============================*/
gulp.task('copy-lib', function () {
  return gulp.src(paths.src_vendor_files)
  .pipe(copy('./build/client/vendor/'));
});

gulp.task('inject-templates', ['ls', 'jade'], function () {
  return gulp.src(paths.directives)
  .pipe(inject(
               gulp.src(paths.html, {'cwd': __dirname + '/build/client'}),
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
    )).pipe(gulp.dest('./build/client/app/'));
});

gulp.task('vendor', ['ls', 'jade'], function () {
  return gulp.src('./build/client/index.html')
  .pipe(inject(
               gulp.src(paths.vendor_files, {'cwd': __dirname + '/build/client', 'read': false}),
               {
                // addRootSlash: false,
                starttag: '<!-- inject:vendor:{{ext}}-->'
              }
              )).pipe(gulp.dest('./build/client'));
});

gulp.task('injection', ['ls', 'stylus', 'jade', 'vendor'], function(){
  return gulp.src('./build/client/index.html')
  .pipe(inject(
               gulp.src(paths.inject_js, {'cwd': __dirname + '/build/client'})
               .pipe(angularFilesort()),
               { addRootSlash: false }
               ))
  .pipe(inject(
               gulp.src(paths.inject_css, {'cwd': __dirname + '/build/client'}), { addRootSlash: false }))
  .pipe(gulp.dest('./build/client'));
});

gulp.task('wiredep', ['injection'], function(){
  return gulp.src('./build/client/index.html')
  .pipe(wiredep({
    directory: paths.bower_dir,
    devDependencies: true
  }))
  .pipe(gulp.dest('./build/client')).pipe(browserSync.stream({once: true}));
});

gulp.task('usemin', ['clean_dist'], function() {
  return gulp.src('./build/index.html')
  .pipe(usemin({
    css: [ minifyCss(), rev() ],
    html: [ minifyHtml({collapseWhitespace: true}) ],
    js: [ uglify({mangle: false}), rev() ],
    inlinejs: [ uglify({beautify:true, mangle: true}) ],
    inlinecss: [ minifyCss() ]
  }))
  .pipe(gulp.dest('./dist/'));
});

/*=====  End of CLIENT  ======*/
/*==============================
=            SERVER            =
==============================*/
gulp.task('copy-package', function (){
  return gulp.src('./src/' + paths.server_package)
  .pipe(copy('./build/', {prefix: 1}));
});


/*=====  End of SERVER  ======*/

/*==============================
=            GLOBAL            =
==============================*/


gulp.task('copy-yml', function () {
  return gulp.src(paths.yml)
  .pipe(copy('./build/', {prefix: 1}));
});

gulp.task('clean_dist', ['build'], function () {
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

/*=====  End of GLOBAL  ======*/

gulp.task('watch', ['build'], function () {
  gulp.watch(paths.src_vendor_files, ['wiredep']);
  gulp.watch(paths.ls, ['stylus', 'inject-templates', 'wiredep']);
  gulp.watch(paths.jade, ['inject-templates', 'wiredep']);
  gulp.watch(paths.stylus, ['stylus', 'wiredep']);
  gulp.watch(paths.bower_files, ['wiredep']);
});

// gulp.task('serve', ['watch'], function () {
//   gulp.src('./build/')
//   .pipe(server({
//     livereload: {
//       enable: true,
//       filter: function (filename, cb) {
//         cb(!/\.ls$|\.jade$|node_modules/.test(filename));
//       }
//     },
//     directoryListing: false,
//     open: true
//   }));
// });
gulp.task('serve', ['nodemon', 'watch'], function() {
  browserSync.init({
      // files: ['./build/**/*.*'],
      injectChanges: true,
      proxy: "http://localhost:5000",
      open: false,
      browser: "google chrome",
      port: 7000,
      proxy: "http://localhost:3000"
  });
});

gulp.task('nodemon', function (cb) {
  var started = false;
  return nodemon({
    script: paths.server
  }).on('start', function () {
    // to avoid nodemon being started multiple times
    // thanks @matthisk
    if (!started) {
      cb();
      started = true;
    }
  });
});

gulp.task('serve-dist', ['dist'], function () {
  gulp.src('./dist/')
  .pipe(server({
    livereload: {
      enable: true,
      port: 35730,
      filter: function (filename, cb) {
        cb(!/\.ls$|\.jade$|node_modules/.test(filename));
      }
    },
    directoryListing: false,
    open: true,
    port: 8001
  }));
});

/*=================================
=            GENERATOR            =
=================================*/

dogen.config({
  templatesPath: 'templates',
  gulp: gulp
});

dogen.task('component', __dirname + '/src/app/');
dogen.task('service', __dirname + '/src/app/');


/*=====  End of GENERATOR  ======*/

gulp.task('build', ['copy-package', 'copy-yml', 'inject-templates', 'stylus', 'vendor', 'injection', 'wiredep']);
gulp.task('dist', ['copy-yml', 'usemin']);
