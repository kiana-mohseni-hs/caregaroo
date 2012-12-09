casper.start(casper.caregaroo.baseurl);

var user = casper.caregaroo.fixtures.networks[0].owner;

casper.then(function () {
  casper.caregaroo.signIn(user);
});

var row;
casper.then(function () {
  //row needs to be offset by one because nth-child is 1-based count
  row = 1+ casper.evaluate(function getRow(name) {
    var members = __utils__.findAll('ul#member_list li a:nth-child(2)');

    for (var i = 0; i < members.length; i++) {
      if (name == members[i].textContent) {
        return i;
      }
    }
  }, {
    name: user.firstName
  });
});

casper.then(function () {
  casper.echo('row: ' + row);
  casper.click('ul#member_list li:nth-child(' + row + ') a:nth-child(2)');
});

var expectedName = user.firstName + ' ' + user.lastName + ' (' + user.relationship + ')';
casper.then(function assertName() {
  casper.test.assertEvalEquals(function getNameText() {
    return __utils__.findOne('.name_text').textContent;
  }, expectedName, 'Verify name');
});

casper.thenClick('a[href="/profile/edit"]');

casper.then(function assertUserInfo() {
  casper.test.assertEvalEquals(function getFirstName() {
    return __utils__.findOne('input#user_first_name').value;
  }, user.firstName, 'Verify first name');

  casper.test.assertEvalEquals(function getLastName() {
    return __utils__.findOne('input#user_last_name').value;
  }, user.lastName, 'Verify last name');

  casper.test.assertEvalEquals(function getEmail() {
    return __utils__.findOne('input#user_email').value;
  }, user.email, 'Verify email');
});

casper.run(function () {
  casper.test.done();
});