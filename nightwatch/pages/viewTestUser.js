const confirmationCommands = {
	isConfirmed: function() {
		return this.api
			.waitForElementPresent('@confirmedStatus')
			.assert.containsText('@confirmedStatus', 'yes');
	},
	isNotConfirmed: function() {
		return this.api
			.waitForElementPresent('@confirmedStatus')
			.assert.containsText('@confirmedStatus', 'no');
	}
}
module.exports = {
	url: function(name) {
		return `${this.api.launchUrl}/test/view_user/${name}`;
	},
	elements: {
		confirmedStatus: '#user-confirmed'
	},
	commands: [confirmationCommands]
};
