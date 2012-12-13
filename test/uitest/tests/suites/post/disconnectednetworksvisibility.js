casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16),
  "recipients": [
    casper.caregaroo.fixtures.networks[0].owner
  ]
};

casper.then(function signIn() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].guests[1]);
});

casper.then(function switchNetwork0() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[0].info);
});

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

casper.then(function signOut() {
  casper.caregaroo.signOut();
});

casper.then(function signIn() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[1].guests[2]);
});

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
  casper.test.assertEquals(isVisible, false, 'Verify message is not visible as outsider.');
});

casper.run(function () {
  casper.test.done();
});