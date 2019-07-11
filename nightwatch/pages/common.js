
const loginStatusCommands = {
	assertLoggedOut() {
		return this.api
			.waitForElementPresent('a.login-link')
			.assert
			.elementPresent('a.login-link');
	},

	assertLoggedIn() {
		return this.api
			.waitForElementPresent('a.logout-link')
			.assert
			.elementPresent('a.logout-link');
	},

	assertLoggedInAs(name) {
		return this.api
			.waitForElementPresent('span.user-name')
			.assert
			.useXpath()
			.elementPresent("//span[@class='user-name' and contains(text(), '" + name + "')]");
	},
};

module.exports = {
	url: function() {
		return this.api.launchUrl;
	},

	commands: [
		loginStatusCommands,
	],
};
