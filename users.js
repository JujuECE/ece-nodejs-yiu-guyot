module.exports = {
	save: function(name, callback) {
		//save the user.....
		var user = {
			id: "2222",
			name: name
		}
		
		callback(name);
	},
	
	get: function(id, callback) {
		//get a user ....
		var user = {
			name: "juju",
			id: id
		}
		
		callback(id);
	}
}