module.exports = {
	url: function(type, name) {
		return `${this.api.launchUrl}/test/view_email/${type}/${name}`;
	}
};
