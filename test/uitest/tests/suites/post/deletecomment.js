casper.start(casper.caregaroo.baseurl);

var news = {
  "message": StringUtilities.randomAlphaString(16)
};

var comment = {
  "news": news,
  "message": StringUtilities.randomAlphaString(16)
};

var switchNetwork2 = function () {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[1].info);
};

var signInUser3 = function signInUser3() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[1].guests[1]);
}

var signInUser4 = function signInUser4() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[1].guests[2]);
}

casper.then(signInUser3);

casper.then(switchNetwork2);

casper.then(function postNews() {
  casper.caregaroo.postNews(news);
});

casper.then(signInUser4);

casper.then(function commentNews() {
  casper.caregaroo.postComment(comment);
});

casper.then(casper.caregaroo.signOut);

casper.then(signInUser3);

casper.then(switchNetwork2);

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

casper.then(function assertComment() {
  casper.test.assertEquals(firstComment, comment.message, 'Verify the comment message is correct.');
  casper.test.assertNotVisible('div#comments_' + newsId + ' span a[data-method="delete"]', 'Verify that the delete button is not visible');
});

casper.then(casper.caregaroo.signOut);

casper.then(signInUser4);

var commentId;
casper.then(function getCommentId() {
  commentId = casper.caregaroo.getCommentId(comment.message);
});

casper.then(function deleteComment() {
  casper.caregaroo.deleteComment(commentId);
});

casper.then(function reloadPage() {
  casper.reload();
});

casper.then(function assertCommentNotVisible() {
  casper.test.assert(!casper.exists('div#comments_' + newsId + ' div div.comment_content div',
    'Verify that the comment is no longer present on the page'));
});

casper.then(casper.caregaroo.signOut);

casper.then(signInUser3);

casper.then(function assertCommentNotVisible() {
  casper.test.assert(!casper.exists('div#comments_' + newsId + ' div div.comment_content div',
    'Verify that the comment is no longer present on the page'));
});

casper.run(function () {
  casper.test.done();
});