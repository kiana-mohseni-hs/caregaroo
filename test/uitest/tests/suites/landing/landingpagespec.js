casper.start(casper.caregaroo.baseurl);

casper.then(function () {
  casper.test.assertEquals(casper.getTitle(), 'Caregaroo: Home Care Coordination', 'Verify title');
});

casper.run(function () {
  casper.test.done();
});