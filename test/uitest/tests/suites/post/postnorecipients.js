casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16),
  "recipients": []
};

casper.then(function signInUser1() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].owner);
});

var alerted = false;
casper.on('remote.alert', function setAlerted(message) {
  if (message === 'choose at least one recipient') {
    alerted = true;
  }
});

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

casper.then(function assertAlert() {
  casper.test.assert(alerted, 'Verify alert box');
});

casper.then(function reloadPage() {
  casper.reload();
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
  casper.test.assertEquals(isVisible, false, 'Verify message is not posted.');
});

casper.run(function () {
  casper.test.done();
});