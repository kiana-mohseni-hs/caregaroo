casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16),
  "recipients": [
    casper.caregaroo.fixtures.networks[0].owner
  ]
};

casper.then(function signInUser2() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].guests[1]);
});

var switchNetwork0 = function switchNetwork0() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[0].info);
};

casper.then(switchNetwork0);

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

casper.then(casper.caregaroo.signOut);

casper.then(function signInUser1() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].guests[0]);
});

casper.then(switchNetwork0);

var isVisible = false;
casper.then(function isMessageVisible() {
  isVisible = casper.evaluate(function isMessageVisible(message) {
    var isMessageVisibleOnDom = false;
    var newsposts = __utils__.findAll('div.post_content_area div');
    for (var i = 0; i < newsposts.length; i++) {
      if (newsposts[i].textContent.trim() === message) {
        isMessageVisibleOnDom = true;
      }
    }

    return isMessageVisibleOnDom;
  }, {
    message: news.message
  });
});

casper.then(function assertNewsNotVisible() {
  casper.test.assertEquals(isVisible, false, 'Verify message is not visible on other network.');
});

casper.then(casper.caregaroo.signOut);

casper.then(function signInUser0() {
  casper.caregaroo.signIn(news.recipients[0]);
});

casper.then(switchNetwork0);

casper.then(function assertNews() {
  casper.test.assertEvalEquals(function getMessage() {
    return __utils__.findAll('div.post_content_area div')[0].textContent.trim();
  }, news.message, 'Verify message was posted correctly.');

  casper.test.assertEvalEquals(function getRecipientCount() {
    return parseInt(jQuery('li.recipient_list_handle').text().trim().split(' ')[0], 10);
  }, news.recipients.length + 1, 'Verify recipients count is correct.');
});

casper.run(function () {
  casper.test.done();
});