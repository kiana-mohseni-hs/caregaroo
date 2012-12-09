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
    "old_password": StringUtilities.randomAlphaString(16),
    "user[password]": newPassword,
    "user[password_confirmation]": newPassword
  }, false);
});

casper.then(submitUpdates);

casper.then(function assertError() {
  casper.test.assertEvalEquals(function getFlashText() {
    return __utils__.findOne('div#flash_alert').textContent;
  }, 'Old password incorrect.', 'Verify error message');
});

casper.then(function fillFormWithMismatchedPasswordConfirmation() {
  casper.fill('form.edit_user', {
    "old_password": user.password,
    "user[password]": newPassword,
    "user[password_confirmation]": StringUtilities.randomAlphaString(16)
  }, false);
});

casper.then(submitUpdates);

casper.then(function assertError() {
  casper.test.assertEvalEquals(function getFlashText() {
    return __utils__.findOne('div.error_messages ul li').textContent;
  }, 'Password doesn\'t match confirmation', 'Verify error message');
});

casper.run(function () {
  casper.test.done();
});