casper.start();

casper.then(function loadTestNetworksFromDisk() {
  var fs = require('fs');
  var pathtonetworksjson = 'tests/pre/networks.json';

  if (fs.exists(pathtonetworksjson)) {
    var json = fs.read(pathtonetworksjson);
    casper.caregaroo.fixtures = {};
    casper.caregaroo.fixtures.networks = JSON.parse(json);
  } else {
    casper.echo('### ERROR: Unable to find ' + pathtonetworksjson);
    casper.exit(1);
  }
});

casper.run(function () {
  casper.test.done();
});
