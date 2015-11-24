var should = require('should');
var users = require ('../lib/users');
describe('Test2 / fail', function () {
  it('Test2 user', function () {
  users.get(11, function (user) {
	user.should.be.equal(12);
  })
  });
});
