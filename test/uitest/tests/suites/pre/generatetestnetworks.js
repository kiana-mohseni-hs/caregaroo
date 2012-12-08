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

casper.then(function () {
  var testUserCount = 6;
  casper.caregaroo.fixtures = {};
  casper.caregaroo.fixtures.users = [];

  for (var i = 0; i < testUserCount; i++) {
    var userInfo = generateUserDetails();
    casper.caregaroo.fixtures.users.push(userInfo);
  }
});

casper.then(function createNetwork1() {
  casper.caregaroo.fixtures.network1Info = generateNetworkInfo();
  casper.caregaroo.fixtures.network1Owner = casper.caregaroo.fixtures.users[0];
  casper.caregaroo.fixtures.network1Guests = [
    casper.caregaroo.fixtures.users[1],
    casper.caregaroo.fixtures.users[2]
  ];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.network1Info,
    casper.caregaroo.fixtures.network1Owner,
    casper.caregaroo.fixtures.network1Guests
  );
});

casper.then(function createNetwork2() {
  casper.caregaroo.fixtures.network2Info = generateNetworkInfo();
  casper.caregaroo.fixtures.network2Owner = casper.caregaroo.fixtures.users[1];
  casper.caregaroo.fixtures.network2Guests = [
    casper.caregaroo.fixtures.users[2],
    casper.caregaroo.fixtures.users[3],
    casper.caregaroo.fixtures.users[4]
  ];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.network2Info,
    casper.caregaroo.fixtures.network2Owner,
    casper.caregaroo.fixtures.network2Guests
  );
});

casper.then(function createNetwork3() {
  casper.caregaroo.fixtures.network3Info = generateNetworkInfo();
  casper.caregaroo.fixtures.network3Owner = casper.caregaroo.fixtures.users[5];
  casper.caregaroo.fixtures.network3Guests = [];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.network3Info,
    casper.caregaroo.fixtures.network3Owner,
    casper.caregaroo.fixtures.network3Guests
  );
});

casper.then(function createNetwork4() {
  casper.caregaroo.fixtures.network4Info = generateNetworkInfo();
  casper.caregaroo.fixtures.network4Owner = casper.caregaroo.fixtures.users[3];
  casper.caregaroo.fixtures.network4Guests = [];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.network4Info,
    casper.caregaroo.fixtures.network4Owner,
    casper.caregaroo.fixtures.network4Guests
  );
});

casper.then(function signIn() {
  casper.caregaroo.signIn({ 
    email:    casper.caregaroo.fixtures.network1Guests[0].email,
    password: casper.caregaroo.fixtures.network1Guests[0].password
  });
});

casper.then(function verificationOfCreatedUser() {
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('#user_dropdown span').textContent;
  }, casper.caregaroo.fixtures.network1Guests[0].firstName, 'Verify that the guest user name in the drop down is correct');
});

casper.run(function () {
  casper.test.done();
});
