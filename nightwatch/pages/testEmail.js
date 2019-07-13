module.exports = {
	url: function(type, username) {
		return `${this.api.launchUrl}/test/view_email/${type}/${username}`;
	},
};
