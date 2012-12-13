casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16),
  "recipients": [
    casper.caregaroo.fixtures.networks[0].guests[0]
  ]
};

var comment = {
  "news": news,
  "message": StringUtilities.randomAlphaString(16)
};

var switchNetwork0 = function switchNetwork0() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[0].info);
};

casper.then(function signInUser0() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].owner);
});

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

casper.then(casper.caregaroo.signOut);

casper.then(function signInUser1() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].guests[0]);
});

casper.then(switchNetwork0);

casper.then(function commentNews() {
  casper.caregaroo.postComment(comment);
});

var newsId;
casper.then(function getNewsId() {
  newsId = casper.caregaroo.getNewsId(news.message);
});

var firstComment;
casper.then(function getFirstComment() {
  firstComment = casper.evaluate(function getFirstComment(newsId) {
    return __utils__.findAll('div#comments_' + newsId + ' div div.comment_content div')[0].textContent;
  }, {
    newsId: newsId
  });
});

casper.then(function assertFirstComment() {
  casper.test.assertEquals(firstComment, comment.message, 'Verify the comment message is correct.');
});

casper.then(casper.caregaroo.signOut);

casper.then(function signInUser0() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].owner);
});

casper.then(function getFirstComment() {
  firstComment = casper.evaluate(function getFirstComment(newsId) {
    return __utils__.findAll('div#comments_' + newsId + ' div div.comment_content div')[0].textContent;
  }, {
    newsId: newsId
  });
});

casper.then(function assertFirstComment() {
  casper.test.assertEquals(firstComment, comment.message, 'Verify the comment message is correct.');
});

casper.then(casper.caregaroo.signOut);

casper.then(function signInUser2() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[0].guests[1]);
});

casper.then(switchNetwork0);

casper.then(function getFirstComment() {
  firstComment = casper.evaluate(function getFirstComment(newsId) {
    return __utils__.findAll('div#comments_' + newsId + ' div div.comment_content div')[0].textContent;
  }, {
    newsId: newsId
  });
});

casper.then(function assertCommentNoVisible() {
  casper.test.assertNotEquals(firstComment, comment.message, 'Verify the comment does not appear in the first post.');
});

casper.run(function () {
  casper.test.done();
});