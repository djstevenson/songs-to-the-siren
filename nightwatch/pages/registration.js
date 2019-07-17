const registrationCommands = {
	register(username, email, password) {
		this
			.setValue('@usernameField', username)
			.setValue('@emailField',    email)
			.setValue('@passwordField', password)
			.click('@submit');
	},
};

export function url() {
	return `${this.api.launchUrl}/user/register`;
}
export const sections = {
	form: {
		selector: '#user-register-form',
		elements: {
			usernameField: '#user-register-name',
			passwordField: '#user-register-password',
			emailField: '#user-register-email',
			usernameError: '#error-user-register-name',
			passwordError: '#error-user-register-password',
			emailError: '#error-user-register-email',
			submit: '#user-register-button',
		},
		commands: [registrationCommands],
	},
};
