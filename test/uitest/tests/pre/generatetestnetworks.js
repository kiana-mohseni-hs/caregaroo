/**
 * Helper function that generates random user information. Password is defaulted to "caregaroo"
 *
 * @return  Object  user information
 */
function generateUserDetails() {
  "use strict";
  return {
    firstName:    StringUtilities.randomAlphaString(16),
    lastName:     StringUtilities.randomAlphaString(16),
    email:        'test+' + StringUtilities.randomAlphaString(16) + '@caregaroo.com',
    password:     'caregaroo',
    relationship: StringUtilities.randomAlphaString(16)
  };
}

/**
 * Helper function that generates random network information.
 *
 * @return  Object  network information
 */
function generateNetworkInfo() {
  "use strict";
  return {
    name:   StringUtilities.randomAlphaString(16),
    forWho: StringUtilities.randomAlphaString(16)
  };
}

/**
 * Creates users and networks to be used by the test suite.
 *  
 * @see  https://docs.google.com/drawings/d/1wPQWoUsnwoWljNACT46S1vSPQ9-3Pm6vCfto9iniDmA/
 */
casper.start(casper.caregaroo.baseurl);

var users = [];
casper.then(function () {
  var testUserCount = 6;
  casper.caregaroo.fixtures = {};
  casper.caregaroo.fixtures.networks = [{}, {}, {}, {}];

  for (var i = 0; i < testUserCount; i++) {
    var userInfo = generateUserDetails();
    users.push(userInfo);
  }
});

casper.then(function createNetwork0() {
  casper.caregaroo.fixtures.networks[0].info = generateNetworkInfo();
  casper.caregaroo.fixtures.networks[0].owner = users[0];
  casper.caregaroo.fixtures.networks[0].guests = [
    users[1],
    users[2]
  ];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.networks[0].info,
    casper.caregaroo.fixtures.networks[0].owner,
    casper.caregaroo.fixtures.networks[0].guests
  );
});

casper.then(function createNetwork1() {
  casper.caregaroo.fixtures.networks[1].info = generateNetworkInfo();
  casper.caregaroo.fixtures.networks[1].owner = users[1];
  casper.caregaroo.fixtures.networks[1].guests = [
    users[2],
    users[3],
    users[4]
  ];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.networks[1].info,
    casper.caregaroo.fixtures.networks[1].owner,
    casper.caregaroo.fixtures.networks[1].guests
  );
});

casper.then(function createNetwork2() {
  casper.caregaroo.fixtures.networks[2].info = generateNetworkInfo();
  casper.caregaroo.fixtures.networks[2].owner = users[5];
  casper.caregaroo.fixtures.networks[2].guests = [];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.networks[2].info,
    casper.caregaroo.fixtures.networks[2].owner,
    casper.caregaroo.fixtures.networks[2].guests
  );
});

casper.then(function createNetwork3() {
  casper.caregaroo.fixtures.networks[3].info = generateNetworkInfo();
  casper.caregaroo.fixtures.networks[3].owner = users[3];
  casper.caregaroo.fixtures.networks[3].guests = [];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.networks[3].info,
    casper.caregaroo.fixtures.networks[3].owner,
    casper.caregaroo.fixtures.networks[3].guests
  );
});

casper.then(function signIn() {
  casper.caregaroo.signIn({ 
    email:    casper.caregaroo.fixtures.networks[0].guests[0].email,
    password: casper.caregaroo.fixtures.networks[0].guests[0].password
  });
});

casper.then(function verificationOfCreatedUser() {
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('#user_dropdown span').textContent;
  }, casper.caregaroo.fixtures.networks[0].guests[0].firstName, 'Verify that the guest user name in the drop down is correct');
});

casper.then(function writeToDisk() {
  var fs = require('fs');
  fs.write('tests/pre/users.json', JSON.stringify(users), 'w');
  fs.write('tests/pre/networks.json', JSON.stringify(casper.caregaroo.fixtures.networks), 'w');
});

casper.run(function () {
  casper.test.done();
});
