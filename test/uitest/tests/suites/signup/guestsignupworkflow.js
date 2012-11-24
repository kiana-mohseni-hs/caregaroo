casper.start(casper.caregaroo.baseurl);

casper.then(function clickCreateNetworkButton() {
  casper.click('form[action="/register_new"] button[id="register_submit pull-right"]');
});

var random = StringUtilities.randomAlphaString(16);
casper.then(function fillSignUpForm() {
  casper.fill('#new_network', {
    'network[name]': random,
    'network[network_for_who]': random,
    'network[users_attributes][0][email]': 'test+' + random + '@caregaroo.com',
    'network[users_attributes][0][first_name]': random,
    'network[users_attributes][0][last_name]': random,
    'network[users_attributes][0][password]': 'caregaroo',
    'network[affiliations_attributes][0][relationship]': random
  }, false);
});

casper.then(function submitForm() {
  casper.click('#create_btn');
});

casper.then(function assertSuccessPageCorrectness() {
  casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/register/success', 'Verify that the success page routing is correct');
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('h3').textContent;
  }, 'Your network has been successfully created!', 'Verify that the success message is on the page');
});

casper.run(function () {
  casper.test.done();
});