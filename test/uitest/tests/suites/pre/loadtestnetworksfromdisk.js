casper.start();

casper.then(function () {
  var json = require('fs').read('tests/suites/pre/networks.json');
  casper.caregaroo.fixtures = {};
  casper.caregaroo.fixtures.networks = JSON.parse(json);
});

casper.run(function () {
  casper.test.done();
});
