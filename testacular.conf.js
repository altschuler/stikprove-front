// base path, that will be used to resolve files and exclude
basePath = './';

// list of files / patterns to load in the browser
files = [
  'test/vendor/jasmine-1.3.1/jasmine.js',
  JASMINE_ADAPTER,
  'js/vendor/jquery-1.9.0.min.js',
  'js/vendor/angular.min.js',
  'js/vendor/angular-resource.min.js',
  'js/vendor/angular-cookies.min.js',
  'js/vendor/angular-ui.min.js',
  'js/vendor/angular-ui-ieshiv.min.js',
  'js/vendor/base64.js',
  'js/vendor/underscore-min.js',

  'test/vendor/angular-mocks.js',

  'js/client.js',
  'test/unit/*.js'
];

// list of files to exclude
//exclude = ['*.coffee'];

// test results reporter to use
// possible values: 'dots', 'progress', 'junit'
reporters = ['progress'];

// web server port
port = 8080;
// cli runner port
runnerPort = 9100;
colors = true;

// level of logging
// possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
logLevel = LOG_INFO;

autoWatch = true;
browsers = ['Firefox'];
captureTimeout = 5000; // borwser timeout
// Continuous Integration mode
// if true, it capture browsers, run tests and exit
singleRun = false;