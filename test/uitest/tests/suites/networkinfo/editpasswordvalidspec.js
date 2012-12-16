casper.start(casper.caregaroo.baseurl);

var user = casper.caregaroo.fixtures.networks[2].owner;

var submitUpdates = function submitUpdates() {
  casper.click('input#save_updates_button');
};

casper.then(function signIn() {
  casper.caregaroo.signIn(user);
});

casper.thenOpen(casper.caregaroo.baseurl + '/profile/edit');

var newPassword = StringUtilities.randomAlphaString(16);

casper.then(function fillFormWithInvalidPassword() {
  casper.fill('form.edit_user', {
    "old_password": user.password,
    "user[password]": newPassword,
    "user[password_confirmation]": newPassword
  }, false);
});

casper.then(submitUpdates);

casper.then(function assertSuccess() {
  casper.test.assertEvalEquals(function getFlashText() {
    return __utils__.findOne('div#flash_notice').textContent;
  }, 'Profile was successfully updated.', 'Verify success message');
});

casper.then(function signOut() {
  casper.caregaroo.signOut();
});

casper.then(function signInNewPassword() {
  casper.caregaroo.signIn({ "email": user.email, "password": newPassword });
});

// restore user data
casper.thenOpen(casper.caregaroo.baseurl + '/profile/edit');

var newPassword = StringUtilities.randomAlphaString(16);

casper.then(function restoreData() {
  casper.fill('form.edit_user', {
    "old_password": newPassword,
    "user[password]": user.password,
    "user[password_confirmation]": user.password
  }, false);
});

casper.then(submitUpdates);

casper.then(function assertSuccess() {
  casper.test.assertEvalEquals(function getFlashText() {
    return __utils__.findOne('div#flash_notice').textContent;
  }, 'Profile was successfully updated.', 'Verify success message');
});

casper.run(function () {
  casper.test.done();
});