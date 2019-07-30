import { Public            } from '../../pages/public'
import { ResetPasswordForm } from '../../forms/reset-password-form'
import { LoginPage         } from '../../pages/user/login-page';

export class ResetPasswordPage extends Public {
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
