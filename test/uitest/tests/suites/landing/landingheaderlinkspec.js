casper.start(casper.caregaroo.baseurl);

casper.thenClick('ul.nav li:nth-child(1) a');

casper.then(function assertHome() {
  casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/', 'Verify that the URL is correct');
});

casper.thenClick('ul.nav li:nth-child(2) a');

casper.then(function assertBenefits() {
  casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/product', 'Verify that the URL is correct');
});

casper.thenClick('ul.nav li:nth-child(3) a');

casper.then(function assertBlog() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'http://blog.caregaroo.com/', 'Verify that the URL is correct');
});

casper.thenOpen(casper.caregaroo.baseurl);

casper.then(function visitHelp() {
  var url = casper.evaluate(function getHrefForHelp() {
    return __utils__.findOne('ul.nav li:nth-child(4) a').getAttribute('href');
  });

  casper.open(url);
});

casper.then(function assertHelp() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'https://caregaroo.zendesk.com/forums', 'Verify that the URL is correct');
});

casper.thenOpen(casper.caregaroo.baseurl);

casper.thenClick('ul.nav li:nth-child(5) form button');

casper.then(function assertSignIn() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'http://cg2-staging.herokuapp.com/login?', 'Verify that the URL is correct');
});

casper.run(function () {
  casper.test.done();
});