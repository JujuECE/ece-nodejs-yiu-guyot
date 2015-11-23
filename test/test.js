var should = require('should');
var users = require ('../lib/users');

describe('server', function () {
  it('Test user', function () {
	  users.get(11, function (user) {
		user.id.should.equal(11);
	  })
  });
});



