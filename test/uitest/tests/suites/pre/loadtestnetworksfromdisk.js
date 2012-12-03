casper.start();

casper.then(function () {
  var dump, networks;
  dump = require('fs').read('tests/suites/pre/testdata.json');
  networks = JSON.parse(dump);
  console.log('networks.network1.networkInfo.name: ' + networks.network1.networkInfo.name);

  casper.test.assertEquals(networks.network1.networkInfo.name, 'Lalalal', 'Verify that we can parse JSON from disk');
});

casper.run(function () {
  casper.test.done();
});
