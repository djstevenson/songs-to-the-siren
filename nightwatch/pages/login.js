const loginCommands = {
	login(username, password) {
		this
			.setValue('@usernameField', username)
			.setValue('@passwordField', password)
			.click('@submit');
	},
};

export function url() {
	return `${this.api.launchUrl}/user/login`;
}
export const sections = {
	form: {
		selector: '#user-login-form',
		elements: {
			usernameField: '#user-login-name',
			passwordField: '#user-login-password',
			usernameError: '#error-user-login-name',
			passwordError: '#error-user-login-password',
			submit: '#login-button',
		},
		commands: [loginCommands],
	},
};
