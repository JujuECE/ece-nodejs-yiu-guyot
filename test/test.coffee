should = require('should')
users = require('../lib/users')
describe 'Test1 / pass', ->
  it 'Test1 user', ->
    users.get 11, (user) ->
      user.should.be.equal 11
      return
    return
  return