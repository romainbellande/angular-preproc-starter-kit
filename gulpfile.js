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
  browserSync     = require('browser-sync').create(),
  shell           = require('gulp-shell'),
  exec            = require('child_process').exec,
  bower           = require('gulp-bower'),
  runSequence     = require('run-sequence'),
  browserify      = require('browserify'),
  source          = require('vinyl-source-stream'),
  derequire       = require('browserify-derequire'),
  open            = require('gulp-open'),
  path            = require('path'),
  lsLint          = require('ls-lint'),
  strip            = require('gulp-strip-comments');

  var reload = browserSync.reload;

  var paths = {
    ls: ['!**/*Spec.ls', '!./src/server/node_modules',  './src/**/*.ls'],
    ls_spec: ['!./src/server/node_modules', './src/**/*Spec.ls'],
    jade: ['!./src/client/index.jade', '!./src/server/node_modules', './src/**/*.jade'],
    jade_index: './src/client/index.jade',
    stylus: ['!./src/**/_*/*.styl', '!./src/**/_styles/**/*.styl', '!./src/**/_*.styl', '!./src/server/node_modules', './src/**/*.styl'],
    js: ['./build/client/app/**/*.js'],
    html: ['app/**/*.html'],
    css: ['client/assets/**/*.css', 'client/app/**/*.css'],
    yml: ['!./src/server/node_modules','src/client/**/*.yml', 'src/server/**/*.yml'],
    json: ['!./src/server/node_modules','src/client/**/*.json' ,'src/server/**/*.json'],
    maps: '.',
    bower_dir: './build/client/lib/',
    bower_files: './build/client/lib/**/*.*',
    inject_js: ['!**/app.**.js', 'app/**/*.js'],
    inject_css: ['assets/**/*.css', 'app/**/*.css'],
    src_vendor_files: ['!./src/client/vendor/**/*.ls', './src/client/vendor/**/*.*'],
    vendor_files: ['!vendor/prelude-ls/*', 'vendor/**/*.js', 'vendor/**/*.css'],
    components: ['./build/client/app/**/*Component.js'],
    server_package: 'server/package.json',
    server: './build/server/bin/server.js',
    server_dist: './dist/server/bin/server.js',
    client: './build/client/index.html'
  };

/*============================
=            AUTO            =
============================*/

gulp.task('ls.c', function() {
  return gulp.src(paths.ls)
  .pipe(sourcemaps.init())
  .pipe(livescript())
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'));
  });

gulp.task('ls-spec.c', function() {
  return gulp.src(paths.ls_spec)
  .pipe(sourcemaps.init())
  .pipe(livescript())
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./spec/'));
  });

gulp.task('index.c', function () {
  return gulp.src(paths.jade_index)
  .pipe(sourcemaps.init())
  .pipe(gulpJade({
    jade: jade,
    pretty: true
    }))
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/client/'));
  });

gulp.task('jade.c', function() {
  return gulp.src(paths.jade)
  .pipe(sourcemaps.init())
  .pipe(gulpJade({
    jade: jade,
    pretty: true
    }))
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'));
  });

gulp.task('stylus.c', function () {
  return gulp.src(paths.stylus)
  .pipe(sourcemaps.init())
  .pipe(stylus())
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'));
  });

gulp.task('compile-jade-index', ['compile'], function () {
  return gulp.src(paths.jade_index)
  .pipe(sourcemaps.init())
  .pipe(gulpJade({
    jade: jade,
    pretty: true
    }))
  .pipe(sourcemaps.write(paths.maps))
  .pipe(gulp.dest('./build/'));
  })

gulp.task('compile', ['ls.c', 'ls-spec.c', 'jade.c', 'stylus.c']);

/*=====  End of AUTO  ======*/

/*==================================
=            INJECTIONS            =
==================================*/

gulp.task('inject-html', function () {
  return gulp.src(paths.components)
  .pipe(inject(
   gulp.src(paths.html, {'cwd': __dirname + '/build/client'}),
   {
    // addRootSlash: false,
    relative: true,
    starttag: 'template: \'',
    endtag: '\'',
    transform: function (filePath, file, i, length, targetFile) {
      if (filePath.indexOf('../render') === 0) {
        console.log('[template injected]: ' + filePath.split('../render/')[1]);
        return escape(minifyHtmlInput(file.contents.toString('utf-8'), {collapseWhitespace: true, preventAttributesEscaping: true}));
      }
    }
  }
  )).pipe(gulp.dest('./build/client/app/'));
  });

gulp.task('inject-css', function () {
  return gulp.src('./build/client/index.html')
  .pipe(
    inject(
     gulp.src(
      paths.inject_css, {'cwd': __dirname + '/build/client'}
      ),
     {
      addRootSlash: false
      })
    )
  .pipe(gulp.dest('./build/client')).pipe(browserSync.stream());
  });

gulp.task('inject-js', function () {
  return gulp.src('./build/client/index.html')
  .pipe(
    inject(
     gulp.src(
      paths.inject_js, {'cwd': __dirname + '/build/client'}
      )
     .pipe(angularFilesort()),
     {
      addRootSlash: false
      })
    )
  .pipe(gulp.dest('./build/client'));
  });

gulp.task('inject-vendors', ['copy-vendors'], function () {
  return gulp.src('./build/client/index.html')
  .pipe(inject(
   gulp.src(paths.vendor_files, {'cwd': __dirname + '/build/client', 'read': false}),
   {
    addRootSlash: false,
    starttag: '<!-- inject:vendor:{{ext}}-->'
  }
  )).pipe(gulp.dest('./build/client'));
  });

gulp.task('bower', function() {
  return bower();
  });

gulp.task('inject-bower', ['bower'], function() {
  return gulp.src('./build/client/index.html')
  .pipe(wiredep({
    directory: paths.bower_dir,
    devDependencies: true
    }))
  .pipe(gulp.dest('./build/client'));
  });

gulp.task('injection', function (callback) {
  runSequence(
    'inject-js',
    'inject-css',
    ['inject-html', 'inject-vendors', 'inject-bower'],
    callback
    );
  });

/*=====  End of INJECTIONS  ======*/
/*==============================
=            OTHERS            =
==============================*/

gulp.task('copy-yml', function () {
  return gulp.src(paths.yml)
  .pipe(copy('./build/', {prefix: 1}));
  });

gulp.task('copy-json', function () {
  return gulp.src(paths.json)
  .pipe(copy('./build/', {prefix: 1}));
  });

gulp.task('copy-vendors', function () {
  return gulp.src(paths.src_vendor_files)
  .pipe(copy('./build/', {prefix: 1}));
  });

gulp.task('copy-server-packages', function () {
  return gulp.src('./src/' + paths.server_package)
  .pipe(copy('./build/', {prefix: 1}));
  });

gulp.task('install-server-packages', ['copy-server-packages'], function () {
  return exec('npm install --prefix ./build/server');
  });

/*=====  End of OTHERS  ======*/
/*================================
=            WATCHERS            =
================================*/

gulp.task('watch-ls', function (callback) {
  runSequence(['ls.c', 'ls-spec.c', 'write-lint'], 'inject-js','inject-html',callback);
  });

gulp.task('watch-jade', function (callback) {
  runSequence('jade.c', 'inject-html', callback);
  });

gulp.task('watch', ['build'], function () {
  gulp.watch(paths.ls, ['watch-ls', reload]);
  gulp.watch(paths.jade, ['watch-jade', reload]);
  gulp.watch(paths.stylus, ['stylus.c']);
  });

/*=====  End of WATCHERS  ======*/

/*=============================
=            BUILD            =
=============================*/


gulp.task('build', function (callback) {
  runSequence(
    'index.c',
    'compile',
    ['injection', 'copy-yml', 'copy-json', 'install-server-packages'],
    callback
    );
  });

/*=====  End of BUILD  ======*/

/*============================
=            DIST            =
============================*/

gulp.task('copy-yml-dist', function () {
  return gulp.src(paths.yml)
  .pipe(copy('./dist/', {prefix: 1}));
  });

gulp.task('clean-dist', ['build'], function () {
  return gulp.src('dist/', {read: false})
  .pipe(clean());
  });

gulp.task('copy-node_modules-dist', function () {
  return gulp.src('./build/server/node_modules/**/*')
  .pipe(copy('./dist/', {prefix: 2}));
});

gulp.task('server-dist', function () {
  return gulp.src(['!./build/server/node_modules/**/*', './build/server/**/*.js'])
  .pipe(strip())
  .pipe(uglify())
  .pipe(gulp.dest(path.join(__dirname, './dist/server')));
  });

gulp.task('copy-build-to-dist', function () {
  gulp.src(['./build/server/node_modules/**/*', './build/server/**/*.json', './build/server/**/*.yml'])
  .pipe(copy('./dist/', {prefix: 1 }));
});

gulp.task('server-dist2', ['clean-dist'], function () {
  return gulp.src(['!./build/server/node_modules/**/*', './build/server/**/*'])
  .pipe(strip())
  .pipe(uglify())
  .pipe(gulp.dest('./dist/server'));
  });

gulp.task('browserify', function () {

  browserify({
    browserField : false,
    entries: './build/server/bin/server.js',
    paths: ['./build/server/', './dist/server/node_modules/'],
    // entries: 'bin/server.js',
    commondir: false,
    builtins: false,
    insertGlobalVars : {
      process: undefined,
      global: undefined,
      'Buffer.isBuffer': undefined,
      Buffer: undefined,

    }
    })
  .bundle()
  .on('error', function(e){
    gutil.log(e);
    })
  .pipe(source('server-bundle.js'))
  .pipe(gulp.dest(path.join(__dirname, './dist/server')));
  });

gulp.task('usemin', function() {
  return gulp.src('./build/client/index.html')
  .pipe(usemin({
    css: [ minifyCss(), rev() ],
    html: [ minifyHtml({collapseWhitespace: true}) ],
    js: [ uglify({mangle: false}), rev() ],
    inlinejs: [ uglify({beautify:true, mangle: true}) ],
    inlinecss: [ minifyCss() ]
    }))
  .pipe(gulp.dest(path.join(__dirname, './dist/client')));
  });

gulp.task('client-dist', ['usemin']);
//gulp.task('server-dist', ['browserify']);
gulp.task('nodemon-dist', ['mongodb'], function (cb) {
  var started = false;
  return nodemon({
    script: paths.server_dist
    }).on('start', function () {
      if (!started) {
        cb();
        started = true;
      }
      });
    });
gulp.task('open-dist', function () {
  gulp.src('./dist').pipe(open({
    uri: 'localhost:3000'
    }));
  });
gulp.task('dist', function (callback) {
  runSequence(['client-dist', 'server-dist', 'copy-build-to-dist'], 'nodemon-dist',  callback);
  });

/*=====  End of DIST  ======*/

/*==============================
=            SERVER            =
==============================*/
gulp.task('data-folder', function () {
  gulp.src(path.join(__dirname, './src/server/db'))
  .pipe(gulp.dest(path.join(__dirname, './build/server')));
  });

gulp.task('mongodb', ['data-folder'], function () {
  exec ('mongod --dbpath ' + __dirname + '/build/server/db');
  });

gulp.task('nodemon-build', ['watch', 'mongodb'], function (cb) {
  var started = false;
  return nodemon({
    script: paths.server
    }).on('start', function () {
      if (!started) {
        cb();
        started = true;
      }
      });
    });

gulp.task('serve', ['nodemon-build'], function() {
  browserSync.init({
    proxy: "http://localhost:5000",
    open: true,
    browser: "google chrome",
    port: 7000,
    proxy: "http://localhost:3000",
    notify: false,
    reloadDelay: 2000
    });
  });

/*=====  End of SERVER  ======*/

/*==============================
=            GLOBAL            =
==============================*/


/*=====  End of GLOBAL  ======*/
gulp.task('write-lint', function (){
  return exec("./node_modules/ls-lint/bin/ls-lint './src/**/**/**/**/*.ls' ./ls-lint.lson > lint_serve/lint.log");
  });

gulp.task('serve-lint', ['write-lint'], function () {
  gulp.src('./lint_serve')
  .pipe(server({
    livereload: {
      enable: true,
      port: 35730
      // filter: function (filename, cb) {
      //   cb(!/\.ls$|\.jade$|node_modules/.test(filename));
      // }
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

dogen.task('component', __dirname + '/src/client/app/');
dogen.task('service', __dirname + '/src/client/app/');
dogen.task('test', __dirname + '/src/client/app/');

/*=====  End of GENERATOR  ======*/

