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

function generateNetworkInfo() {
  "use strict";
  return {
    name:   StringUtilities.randomAlphaString(16),
    forWho: StringUtilities.randomAlphaString(16)
  };
}

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

casper.then(function () {
  // Network 1
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

casper.then(function () {
  // Network 2
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

//// Network 3
casper.then(function () {
  casper.caregaroo.fixtures.network3Info = generateNetworkInfo();
  casper.caregaroo.fixtures.network3Owner = casper.caregaroo.fixtures.users[5];
  casper.caregaroo.fixtures.network3Guests = [];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.network3Info,
    casper.caregaroo.fixtures.network3Owner,
    casper.caregaroo.fixtures.network3Guests
  );
});

// Network 4
casper.then(function () {
  casper.caregaroo.fixtures.network4Info = generateNetworkInfo();
  casper.caregaroo.fixtures.network4Owner = casper.caregaroo.fixtures.users[3];
  casper.caregaroo.fixtures.network4Guests = [];

  casper.caregaroo.createNetwork(
    casper.caregaroo.fixtures.network4Info,
    casper.caregaroo.fixtures.network4Owner,
    casper.caregaroo.fixtures.network4Guests
  );
});

casper.then(function () {
  casper.caregaroo.signIn({ 
    email:    casper.caregaroo.fixtures.network1Guests[0].email,
    password: casper.caregaroo.fixtures.network1Guests[0].password
  });
});

casper.then(function () {
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('#user_dropdown span').textContent;
  }, casper.caregaroo.fixtures.network1Guests[0].firstName, 'Verify that the guest user name in the drop down is correct');
});

casper.run(function () {
  casper.test.done();
});
