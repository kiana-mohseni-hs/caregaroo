casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16)
};

casper.then(function signInUser3() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[3].owner);
});

casper.then(function switchNetwork3() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[3].info);
});

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

casper.then(function assertNews() {
  casper.test.assertEvalEquals(function getFirstNewsMessage() {
    return __utils__.findAll('div.post_content_area div')[0].textContent.trim();
  }, news.message, 'Verify message was posted correctly.');

//  casper.test.assertEvalEquals(function getFirstNewsRecipientCount() {
//    return parseInt(jQuery('li.recipient_list_handle').text().trim().split(' ')[0], 10);
//  }, 1, 'Verify recipients count is correct.');
});

var newsId;
casper.then(function getPostId() {
  newsId = casper.caregaroo.getNewsId(news.message);
});

casper.then(function deletePost() {
  casper.caregaroo.deleteNews(newsId);
});

var firstNewsPost;
casper.then(function getFirstNewsMessage() {
  firstNewsPost = casper.evaluate(function getFirstNewsMessage() {
    return __utils__.findAll('div.post_content_area div')[0].textContent.trim();
  });
});
casper.then(function assertNewsNotVisible() {
  casper.test.assertNotEquals(firstNewsPost, news.message, 'Verify message no longer exists');
});

casper.run(function () {
  casper.test.done();
});