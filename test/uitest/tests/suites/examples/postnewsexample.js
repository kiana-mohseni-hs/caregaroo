casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16),
  "recipients": [
    casper.caregaroo.fixtures.networks[0].owner
  ]
};

casper.then(function signIn() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].guests[0]);
});

casper.then(function switchNetwork() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[0].info);
});

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

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