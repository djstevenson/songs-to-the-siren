const registrationCommands = {
	register(username, email, password) {
		this
			.setValue('@usernameField', username)
			.setValue('@emailField',    email)
			.setValue('@passwordField', password)
			.click('@submit');
	},
};

module.exports = {
	url: function() {
		return `${this.api.launchUrl}/user/register`;
	},
	sections: {
		loginForm: {
			selector: '#user-register-form',
			elements: {
				usernameField: '#user-register-name',
				passwordField: '#user-register-password',
				emailField:    '#user-register-email',
				usernameError: '#error-user-register-name',
				passwordError: '#error-user-register-password',
				emailError:    '#error-user-register-email',
				submit:        '#user-register-button',
			},
			commands: [registrationCommands],
		},
	},
};
