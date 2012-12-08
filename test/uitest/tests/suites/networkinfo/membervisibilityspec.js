casper.start(casper.caregaroo.baseurl);

casper.then(function signIn() {
  casper.caregaroo.signIn(casper.caregaroo.fixtures.networks[1].guests[2]);
});

var members = [];
casper.then(function () {
  members.push({ "member": casper.caregaroo.fixtures.networks[1].owner, "isFound": false });
  casper.caregaroo.fixtures.networks[1].guests.forEach(function (element, index) {
    members.push({ "member": element, "isFound": false });
  });
});

casper.then(function () {
  members.forEach(function (element, index) {
    var memberName = '';

    for (var n = 1; n <= 4; n++) {
      memberName = casper.evaluate(function (nodeNumber) {
        return __utils__.findOne('ul#member_list li:nth-child(' + nodeNumber + ') a:nth-child(2)').textContent;
      }, {
        nodeNumber: n
      });
      casper.echo('memberName: ' + memberName);
      casper.echo('element firstname: ' + element.member.firstName);
      if (memberName === element.member.firstName) {
        element.isFound = true;
      }
    }
  });
});

casper.then(function assertMemberNames() {
  members.forEach(function (element, index) {
    casper.test.assert(element.isFound, 'Verify that the member exists on the network');
  });
});

casper.then(function assertMemberCount() {
  casper.test.assertEvalEquals(function getMemberCount() {
    return __utils__.findAll('ul#member_list li').length - 1; // one of the nodes is "All Members link
  }, members.length, 'Verify member count');
});

casper.run(function () {
  casper.test.done();
});