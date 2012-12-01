casper.start(casper.caregaroo.baseurl);

var commonPassword = 'caregaroo';

var network1Info = {
  name:   StringUtilities.randomAlphaString(16),
  forWho: StringUtilities.randomAlphaString(16)
};

var network1Owner = {
  firstName:    StringUtilities.randomAlphaString(16),
  lastName:     StringUtilities.randomAlphaString(16),
  email:        'test+' + StringUtilities.randomAlphaString(16) + '@caregaroo.com',
  password:     commonPassword,
  relationship: StringUtilities.randomAlphaString(16)
};

var network1Guests = [{ 
  firstName: StringUtilities.randomAlphaString(16),
  lastName: StringUtilities.randomAlphaString(16),
  email: 'test+' + StringUtilities.randomAlphaString(16) + '@caregaroo.com',
  password: commonPassword,
  relationship: StringUtilities.randomAlphaString(16)
}, {
  firstName: StringUtilities.randomAlphaString(16),
  lastName: StringUtilities.randomAlphaString(16),
  email: 'test+' + StringUtilities.randomAlphaString(16) + '@caregaroo.com',
  password: commonPassword,
  relationship: StringUtilities.randomAlphaString(16)
}];

casper.then(function createNetwork1() {
  casper.caregaroo.createNetwork(network1Info, network1Owner, network1Guests);
});

casper.then(function () {
  casper.caregaroo.signIn({ email: network1Guests[0].email, password: commonPassword });
});

casper.then(function () {
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('#user_dropdown span').textContent;
  }, network1Guests[0].firstName, 'Verify that the guest user name in the drop down is correct');
});

casper.run(function () {
  casper.test.done();
});
