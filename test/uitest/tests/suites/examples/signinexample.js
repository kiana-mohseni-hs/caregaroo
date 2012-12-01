casper.start(casper.caregaroo.baseurl);

casper.then(function signIn() {
  var credentials = {
    email:    'julien.escueta+caregaroo11242012b@gmail.com',
    password: 'caregaroo'
  };
  casper.caregaroo.signIn(credentials);
});

casper.then(function assertUserDropdownNameIsCorrect() {
  casper.test.assertEvalEquals(function () {
    return __utils__.findOne('dl#user_dropdown dt a span').textContent;
  }, 'JUlien', 'Verify that the user dropdown name is correct');
});

casper.run(function () {
  casper.test.done();
});
