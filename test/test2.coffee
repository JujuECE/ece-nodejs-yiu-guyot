should = require('should')
users = require('../lib/users')
describe 'Test2 / fail', ->
  it 'Test2 user', ->
    users.get 11, (user) ->
      user.should.be.equal 12
      return
    return
  return