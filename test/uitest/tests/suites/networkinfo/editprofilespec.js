casper.start(casper.caregaroo.baseurl);

var user = casper.caregaroo.fixtures.networks[2].owner;

casper.then(function signIn() {
  casper.caregaroo.signIn(user);
});

casper.thenOpen(casper.caregaroo.baseurl + '/profile/edit');

var firstName = StringUtilities.randomAlphaString(16);
var lastName = StringUtilities.randomAlphaString(16);
casper.then(function fillForm() {
  casper.fill('form.edit_user', {
    "user[first_name]": firstName,
    "user[last_name]": lastName
  }, false);
});

casper.thenClick('input#save_updates_button');

casper.then(function assertChanges() {
  casper.test.assertEvalEquals(function getNotice() {
    return __utils__.findOne('div#flash_notice').textContent;
  }, 'Profile was successfully updated.', 'Verify flash notice');

  casper.test.assertEvalEquals(function getNameText() {
    return __utils__.findOne('p.name_text').textContent;
  }, firstName + ' ' + lastName + ' (' + user.relationship + ')', 'Verify name');

  casper.test.assertEvalEquals(function getProfileName() {
    return __utils__.findAll('div.profile_content div.right_text')[0].textContent;
  }, firstName + ' ' + lastName, 'Verify profile name');

  var isFound = false;
  casper.then(function isNameInMemberList() {
    isFound = casper.evaluate(function checkNameInMemberList(name) {
      var isFound = false;
      var members = __utils__.findAll('ul#member_list li a:nth-child(2)');
      for (var i = 0; i < members.length; i++) {
        if (name == members[i].textContent) {
          isFound = true;
          break;
        }
      }
      return isFound;
    }, {
      name: firstName
    });
  });

  casper.then(function assertIsNameInMemberList() {
    casper.test.assert(isFound, 'Verify name exists in member list');
  });
});

// restore user data
casper.thenOpen(casper.caregaroo.baseurl + '/profile/edit');

casper.then(function restoreUserData() {
  casper.fill('form.edit_user', {
    "user[first_name]": user.firstName,
    "user[last_name]": user.lastName
  }, false);
});

casper.thenClick('input#save_updates_button');

casper.run(function () {
  casper.test.done();
});