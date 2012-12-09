casper.start(casper.caregaroo.baseurl);

var user = casper.caregaroo.fixtures.networks[1].owner;

casper.then(function signIn() {
  casper.caregaroo.signIn(user);
});

casper.then(function switchnetwork1() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[1].info);
});

casper.then(function assertNetworkEditable() {
  casper.test.assertEvalEquals(function getEditNetworkHref() {
    return __utils__.findOne('ul#nav_list li:nth-child(4) a').getAttribute('href');
  }, '/network/edit', 'Verify network edit href');
});

casper.then(function switchnetwork0() {
  casper.caregaroo.switchNetwork(casper.caregaroo.fixtures.networks[0].info);
});

casper.then(function assertNetworkNotEditable() {
  casper.test.assert(!casper.exists('ul#nav_list a[href="/network/edit"]', 'Verify network edit button does not exist'));
});

casper.thenOpen(casper.caregaroo.baseurl + '/network/edit', function assertEditNetworkRoute() {
  casper.test.assertEquals(casper.getCurrentUrl(), casper.caregaroo.baseurl + '/news', 'Verify non starter user routes to /news when accessing /network/edit');
});

casper.run(function () {
  casper.test.done();
});