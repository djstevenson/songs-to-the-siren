import { Common            } from '../pages/common'
import { ResetPasswordForm } from '../forms/reset-password-form'
import { LoginPage } from './login-page';

export class ResetPasswordPage extends Common {
    constructor() {
        super()
        this._form = new ResetPasswordForm()
    }

    resetPassword(password) {
        this.getForm().enter(new Map([['password', password]]))

        return this
    }

    clickLogin() {
        cy.contains("Login").click()
        return new LoginPage();
    }
}
