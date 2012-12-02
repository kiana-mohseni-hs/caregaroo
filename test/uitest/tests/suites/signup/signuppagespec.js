casper.start(casper.caregaroo.baseurl);

casper.then(function clickCreateNetworkButton() {
  casper.click('form[action="/register_new"] button[id="register_submit pull-right"]');
});

casper.then(function assertUrlIsCorrect() {
  casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/register_new');
});

casper.then(function assertThatInputsExist() {
  casper.test.assert(casper.visible('#network_name'), 'Verify that the Network Name input is visible');
  casper.test.assert(casper.visible('#network_network_for_who'), 'Verify that the Network For Who input is visible');
  casper.test.assert(casper.visible('#network_users_attributes_0_email'), 'Verify that the User Email input is visible');
  casper.test.assert(casper.visible('#network_users_attributes_0_first_name'), 'Verify that the User First Name input is visible');
  casper.test.assert(casper.visible('#network_users_attributes_0_last_name'), 'Verify that User the Last Name input is visible');
  casper.test.assert(casper.visible('#network_users_attributes_0_password'), 'Verify that the User Password input is visible');
  casper.test.assert(casper.visible('#network_affiliations_attributes_0_relationship'), 'Verify that the Affiliation Relationship input is visible');
  casper.test.assert(casper.visible('#create_btn'), 'Verify that the submit button is visible');
});

casper.run(function () {
  casper.test.done();
});