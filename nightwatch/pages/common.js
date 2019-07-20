
const loginStatusCommands = {
	assertLoggedOut() {
		const css = 'a.login-link';
		return this.api
			.waitForElementPresent(css)
			.assert
			.elementPresent(css);
	},

	assertLoggedIn() {
		const css = 'a.logout-link';
		return this.api
			.waitForElementPresent(css)
			.assert
			.elementPresent(css);
	},

	assertLoggedInAs(name) {
		const elementCss = 'span.user-name';
		const valueXpath = "//span[@class='user-name' and contains(text(), '" + name + "')]";
		return this.api
			.waitForElementPresent(elementCss)
			.useXpath()
			.assert
			.elementPresent(valueXpath)
			.useCss();
	},
};

const flashCommands = {
	assertFlash(message) {
		const elementCss = 'div#flash-msg';
		const valueXpath = "//*[@id='flash-msg' and contains(text(), '" + message + "')]";
		return this.api
			.waitForElementPresent(elementCss)
			.useXpath()
			.assert
			.elementPresent(valueXpath)
			.useCss();
	}
};

const notificationCommands = {
	assertNotification(message) {
		const elementCss = 'div.notification > p:first-child';
		const valueXpath = "//div[@class='notification']/p[contains(text(), '" + message + "')]";
		return this.api
			.waitForElementPresent(elementCss)
			.useXpath()
			.assert
			.elementPresent(valueXpath)
			.useCss();
	}
};

module.exports = {
	url: function() {
		return this.api.launchUrl;
	},
	commands: [
		loginStatusCommands,
		flashCommands,
		notificationCommands
	],
};
