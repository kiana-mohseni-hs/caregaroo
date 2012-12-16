casper.start(casper.caregaroo.baseurl);

casper.thenClick('ul.quick-links li:nth-child(1) a');

casper.then(function assertHome() {
  casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/', 'Verify that the URL is correct');
});

casper.thenClick('ul.quick-links li:nth-child(2) a');

casper.then(function assertBenefits() {
  casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/product', 'Verify that the URL is correct');
});

casper.thenClick('ul.quick-links li:nth-child(3) a');

casper.then(function assertBlog() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'http://blog.caregaroo.com/', 'Verify that the URL is correct');
});

casper.thenOpen(casper.caregaroo.baseurl);

casper.thenClick('ul.quick-links li:nth-child(4) a');

casper.then(function assertAboutUs() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'http://blog.caregaroo.com/about-us/', 'Verify that the URL is correct');
});

casper.thenOpen(casper.caregaroo.baseurl);

casper.thenClick('ul.quick-links li:nth-child(5) a');

casper.then(function assertNewsMedia() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'http://blog.caregaroo.com/News-Media/', 'Verify that the URL is correct');
});

casper.thenOpen(casper.caregaroo.baseurl);

casper.thenClick('ul.quick-links li:nth-child(6) a');

casper.then(function assertPartners() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'http://blog.caregaroo.com/partners/', 'Verify that the URL is correct');
});

casper.thenOpen(casper.caregaroo.baseurl);

casper.thenClick('ul.quick-links li:nth-child(7) a');

casper.then(function assertJobs() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'http://blog.caregaroo.com/jobs/', 'Verify that the URL is correct');
});

casper.thenOpen(casper.caregaroo.baseurl);

casper.then(function visitHelp() {
  var url = casper.evaluate(function () {
    return __utils__.findOne('ul.quick-links li:nth-child(8) a').getAttribute('href');
  });
  casper.open(url);
});

casper.then(function assertHelp() {
  casper.test.assertEquals(casper.getCurrentUrl(), 'https://caregaroo.zendesk.com/forums', 'Verify that the URL is correct');
});

casper.run(function () {
  casper.test.done();
});