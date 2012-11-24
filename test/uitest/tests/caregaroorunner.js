/**
 * Caregaroo class
 * We can modularize this in the near future
 */
var Caregaroo = function Caregaroo(casper) {
  "use strict";
  var casper = casper;
  this.baseurl = casper.cli.get('url'); // || "http://localhost";
};

/**
 * Check if the user is signed in
 *
 * @return  bool  Returns true if user is signed in.
 */
Caregaroo.prototype.isSignedIn = function checkSignedIn() {
  "use strict";
  return casper.visible('a[href="/logout"]');
}

/**
 * Signs out the user
 *
 */
Caregaroo.prototype.signOut = function signOut() {
  "use strict";
  casper.then(function () {
    casper.click('a[href="/logout"]');
  });
}

/*global phantom*/

if (!phantom.casperLoaded) {
  console.log('This script must be invoked using the casperjs executable');
  phantom.exit(1);
}

var fs           = require('fs');
var colorizer    = require('colorizer');
var utils        = require('utils');
var f            = utils.format;
var loadIncludes = ['includes', 'pre', 'post'];
var tests        = [];
var casper       = require('casper').create({
  onError: function(self, m) {
    console.log('FATAL: ' + m);
    self.exit();
  },
  pageSettings: {
    userAgent: 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11'
  }
  //exitOnError: false
});
var caregaroo    = new Caregaroo(casper);
casper.caregaroo = caregaroo;

// local utils
function checkSelfTest(tests) {
  "use strict";
  var isCasperTest = false;
  tests.forEach(function(test) {
    var testDir = fs.absolute(fs.dirname(test));
      if (fs.isDirectory(testDir)) {
        if (fs.exists(fs.pathJoin(testDir, '.casper'))) {
          isCasperTest = true;
        }
      }
  });
  return isCasperTest;
}

function checkIncludeFile(include) {
  "use strict";
  var absInclude = fs.absolute(include.trim());
  if (!fs.exists(absInclude)) {
    casper.warn("%s file not found, can't be included", absInclude);
    return;
  }
  if (!utils.isJsFile(absInclude)) {
    casper.warn("%s is not a supported file type, can't be included", absInclude);
    return;
  }
  if (fs.isDirectory(absInclude)) {
    casper.warn("%s is a directory, can't be included", absInclude);
    return;
  }
  if (tests.indexOf(include) > -1 || tests.indexOf(absInclude) > -1) {
    casper.warn("%s is a test file, can't be included", absInclude);
    return;
  }
  return absInclude;
}

// parse some options from cli
casper.options.verbose = casper.cli.get('direct') || false;
casper.options.logLevel = casper.cli.get('log-level') || "error";
if (casper.cli.get('no-colors') === true) {
  var cls = 'Dummy';
  casper.options.colorizerType = cls;
  casper.colorizer = colorizer.create(cls);
}

// test paths are passed as args
if (casper.cli.args.length) {
  tests = casper.cli.args.filter(function(path) {
    "use strict";
    return fs.isFile(path) || fs.isDirectory(path);
  });
} else {
  casper.echo('No test path passed, exiting.', 'RED_BAR', 80);
  casper.exit(1);
}

// check for casper selftests
if (!phantom.casperSelfTest && checkSelfTest(tests)) {
  casper.warn('To run casper self tests, use the `selftest` command.');
  casper.exit(1);
}

// includes handling
this.loadIncludes.forEach(function(include){
  "use strict";
  var container;
  if (casper.cli.has(include)) {
    container = casper.cli.get(include).split(',').map(function(file) {
      return checkIncludeFile(file);
    }).filter(function(file) {
      return utils.isString(file);
    });

    casper.test.loadIncludes[include] = utils.unique(container);
  }
});

// test suites completion listener
casper.test.on('tests.complete', function() {
  "use strict";
  this.renderResults(true, undefined, casper.cli.get('xunit') || undefined);
});

casper.on('started', function () {
  "use strict";
  casper.then(function () {
    if (casper.caregaroo.isSignedIn()) {
      casper.echo('Spec started signed in. Signing out');
      casper.caregaroo.signOut();
    }
  });
});

// run all the suites
casper.test.runSuites.apply(casper.test, tests);
