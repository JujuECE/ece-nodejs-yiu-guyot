var should = require('should');
var users = require ('../users')
describe('server', function () {
  it('start & stop', function () {
  users.get(11, function (user) {
	user.id.should.equal(11);
  })
  });
});