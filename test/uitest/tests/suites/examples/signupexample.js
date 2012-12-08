/**
 * Example spec of the usage of the signUp helper function.
 *
 * @see  casper.caregaroo.signUp
 */
casper.start(casper.caregaroo.baseurl);

var networkInfo = {
  name: StringUtilities.randomAlphaString(16),
  forWho: StringUtilities.randomAlphaString(16)
};

var networkOwner = {
  firstName: StringUtilities.randomAlphaString(16),
  lastName: StringUtilities.randomAlphaString(16),
  email: 'test+' + StringUtilities.randomAlphaString(16) + '@caregaroo.com',
  password: 'caregaroo',
  relationship: StringUtilities.randomAlphaString(16)
};

casper.then(function signUp() {
  casper.caregaroo.signUp(networkInfo, networkOwner);
});

casper.then(function signIn() {
  casper.caregaroo.signIn({ email: networkOwner.email, password: networkOwner.password });
});

casper.thenOpen(casper.caregaroo.baseurl + '/news');

casper.then(function assertUserDropdownNameIsCorrect() {
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('dl#user_dropdown dt a span').textContent;
  }, networkOwner.firstName, 'Verify that the user dropdown name is correct');
});

casper.run(function () {
  casper.test.done();
});
