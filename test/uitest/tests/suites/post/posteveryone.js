casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16)
};

casper.then(function signInUser4() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[1].guests[2]);
});

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

var assertNews = function assertNews() {
  casper.test.assertEvalEquals(function getFirstNewsMessage() {
    return __utils__.findAll('div.post_content_area div')[0].textContent.trim();
  }, news.message, 'Verify message was posted correctly.');
  //  casper.test.assertEvalEquals(function getFirstNewsRecipientCount() {
  //    return parseInt(jQuery('li.recipient_list_handle').text().trim().split(' ')[0], 10);
  //  }, 4, 'Verify recipients count is correct.');
};

casper.then(assertNews);

casper.then(function signOut() {
  casper.caregaroo.signOut();
});

casper.then(function signInUser3() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[1].guests[1]);
});

casper.then(function switchNetwork1() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[1].info);
});

casper.then(assertNews);

casper.run(function () {
  casper.test.done();
});