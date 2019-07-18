const linkCommands = {
	clickLink(name) {
		return this
			.click(name);
	},
};
module.exports = {
	url: function(type, name) {
		return `${this.api.launchUrl}/test/view_email/${type}/${name}`;
	},
	sections: {
		urls: {
			selector: "#email",
			elements: {
				goodConfirm: "#email-urls-good-confirm > a",
				goodDecline: "#email-urls-good-decline > a",
			},
			commands: [linkCommands]
		}
	}
};
