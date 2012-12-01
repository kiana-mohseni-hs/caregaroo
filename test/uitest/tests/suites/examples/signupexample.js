casper.start(casper.caregaroo.baseurl);

var firstName = StringUtilities.randomAlphaString(16);
casper.then(function signIn() {
  var networkInfo = {
    name:   StringUtilities.randomAlphaString(16),
    forWho: StringUtilities.randomAlphaString(16)
  };
  
  var networkOwner = {
    firstName:    firstName,
    lastName:     StringUtilities.randomAlphaString(16),
    email:        'test+' + StringUtilities.randomAlphaString(16) + '@caregaroo.com',
    password:     'caregaroo',
    relationship: StringUtilities.randomAlphaString(16)
  };
  
  casper.caregaroo.signUp(networkInfo, networkOwner);
});

casper.thenOpen(casper.caregaroo.baseurl + '/news');

casper.then(function assertUserDropdownNameIsCorrect() {
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('dl#user_dropdown dt a span').textContent;
  }, firstName, 'Verify that the user dropdown name is correct');
});

casper.run(function () {
  casper.test.done();
});
