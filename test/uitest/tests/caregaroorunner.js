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
  return casper.exists('a[href="/logout"]');
}

/**
 * Signs in the user
 *
 * @param  Object  credentials  User credentials to sign in as
 */
Caregaroo.prototype.signIn = function signIn(credentials) {
  "user strict";
  
  casper.thenOpen(casper.caregaroo.baseurl + '/login');
  
  casper.then(function fillForm() {
    casper.fill('#login_form', {
      'session[email]': credentials.email,
      'session[password]': credentials.password
    }, false);
  });
  
  casper.then(function clickSignInButton() {
    casper.click('#sign_in_button');
  });
}

/**
 * Signs out the user
 *
 */
Caregaroo.prototype.signOut = function signOut() {
  "use strict";
  casper.thenOpen(casper.caregaroo.baseurl + '/logout');
//  casper.then(function () {
//    casper.click('a[href="/logout"]');
//  });
}

/**
 * Signs up a user
 *
 * @param  object  networkInfo   Carer network information
 * @param  object  networkOwner  Network owner
 */
Caregaroo.prototype.signUp = function signUp(networkInfo, networkOwner) {
  "use strict";
  casper.then(function navigateToRegistrationPage() {
    casper.open(casper.caregaroo.baseurl + '/register');
  });
  
  casper.then(function fillForm() {
    casper.fill('#new_network', {
      'network[name]': networkInfo.name,
      'network[network_for_who]': networkInfo.forWho,
      'network[users_attributes][0][email]': networkOwner.email,
      'network[users_attributes][0][first_name]': networkOwner.firstName,
      'network[users_attributes][0][last_name]': networkOwner.lastName,
      'network[users_attributes][0][password]': networkOwner.password,
      'network[affiliations_attributes][0][relationship]': networkOwner.relationship
    }, false);
  });
  
  casper.then(function submitForm() {
    casper.click('#create_btn');
  });
  
  casper.then(function () {
    casper.caregaroo.signOut();
  });
}

/**
 * Create network
 *
 * @param   object  networkInfo
 * @param   object  networkOwner
 * @param   object  inviteeUsers  object array of users to be invited to the network
 * @return  int     networkId
*/
Caregaroo.prototype.createNetwork = function createNetwork(networkInfo, networkOwner, inviteUsers) {
  "use strict";

  // sign up networkOwner using networkInfo
  casper.then(function () {
    casper.caregaroo.signUp(networkInfo, networkOwner);
  });

  casper.then(function () {
    casper.caregaroo.signIn({ email: networkOwner.email, password: networkOwner.password });
  });

  casper.then(function () {
    // loop through inviteUsers and invite them
    var invite = function invite(userInfo) {
      casper.thenOpen(casper.caregaroo.baseurl + '/invite');

      casper.then(function fillForm() {
        casper.fill('.new_invitation', {
          'invitation[email]': userInfo.email,
          'invitation[first_name]': userInfo.firstName,
          'invitation[last_name]': userInfo.lastName
        }, false);
      });

      casper.then(function submitForm() {
        casper.click('#submit_invite_btn');
      });

      casper.then(function getInviteToken() {
        userInfo.inviteToken = casper.evaluate(function () {
          return __utils__.findOne('#token').getAttribute('value');
        });
      });
    };

    inviteUsers.forEach(invite);
  });

  casper.then(function () {
    casper.caregaroo.signOut();
  });

  casper.then(function () {
    //loop through inviteUsers and sign up invites with the token
    var inviteeSignup = function inviteeSignup(userInfo) {
      casper.thenOpen(casper.caregaroo.baseurl + '/signup/' + userInfo.inviteToken);

      casper.then(function detectIfUserAlreadySignedUp() {
        if (casper.getCurrentUrl() == casper.caregaroo.baseurl + '/signup/' + userInfo.inviteToken) {
          casper.then(function fillForm() {
            casper.fill('form#new_user', {
              'user[password]': userInfo.password,
              'relationship': userInfo.relationship
            }, false);
          });

          casper.then(function submitForm() {
            casper.click('#signup_next_btn');
          });

          casper.then(function assertSignUpSuccessPage() {
            casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/signup/success', 'Verify that the sign up success page is loaded');
          });
        } else if (casper.getCurrentUrl() == casper.caregaroo.baseurl + '/login') {
          // user is already signed up; don't do anything
        } else {
          casper.test.fail('Something bad happened while processing an invited user');
        }
      });

      casper.then(function () {
        casper.caregaroo.signOut();
      });
    };

    inviteUsers.forEach(inviteeSignup);
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
  },
  clientScripts: [
    'tests/includes/StringUtilities.js'
  ]
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

// event listener to ensure test begins with a non-logged-in session
casper.on('started', function () {
  //"use strict";
  casper.then(function () {
    if (casper.caregaroo.isSignedIn()) {
      casper.echo('Spec started signed in. Signing out');
      casper.caregaroo.signOut();
    }
  });
});

// run all the suites
casper.test.runSuites.apply(casper.test, tests);
