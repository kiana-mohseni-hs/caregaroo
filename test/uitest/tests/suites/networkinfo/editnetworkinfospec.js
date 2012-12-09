casper.start(casper.caregaroo.baseurl);

var user = casper.caregaroo.fixtures.networks[0].owner;
var info = casper.caregaroo.fixtures.networks[0].info;
var newNetworkName = StringUtilities.randomAlphaString(16);

casper.then(function signIn() {
  casper.caregaroo.signIn(user);
});

casper.thenOpen(casper.caregaroo.baseurl + '/network/edit');

casper.then(function fillForm() {
  casper.fill('form.edit_network', {
    "network[name]": newNetworkName
  }, false);
});

casper.then(function submit() {
  casper.click('input[name="commit"]');
});

casper.then(function assertSuccess() {
  casper.test.assertEvalEquals(function getFlashNotice() {
    return __utils__.findOne('div#flash_notice').textContent;
  }, 'Network info was successfully updated.', 'Verify success message');

  casper.test.assertEvalEquals(function getCoCName() {
    return __utils__.findOne('p#CoC_name').textContent;
  }, newNetworkName, 'Verify CoC name');
});

// restore data
casper.thenOpen(casper.caregaroo.baseurl + '/network/edit');

casper.then(function fillForm() {
  casper.fill('form.edit_network', {
    "network[name]": info.name
  }, false);
});

casper.then(function submit() {
  casper.click('input[name="commit"]');
});

casper.then(function assertSuccess() {
  casper.test.assertEvalEquals(function getFlashNotice() {
    return __utils__.findOne('div#flash_notice').textContent;
  }, 'Network info was successfully updated.', 'Verify success message');

  casper.test.assertEvalEquals(function getCoCName() {
    return __utils__.findOne('p#CoC_name').textContent;
  }, info.name, 'Verify CoC name');
});

casper.run(function () {
  casper.test.done();
});