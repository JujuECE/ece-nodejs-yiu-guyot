var should = require('should');
var users = require ('../lib/users');
describe('Test1 / pass', function () {
  it('Test1 user', function () {
  users.get(11, function (user) {
	user.should.be.equal(11);
  })
  });
});
