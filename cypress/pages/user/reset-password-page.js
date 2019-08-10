import { Public            } from '../../pages/public'
import { ResetPasswordForm } from '../../forms/reset-password-form'
import { LoginPage         } from '../../pages/user/login-page';

export class ResetPasswordPage extends Public {
    pageUrl() {
        cy.assert
    }

    constructor() {
        super()
        this._form = new ResetPasswordForm()
    }

    resetPassword(password) {
        this.getForm().enter({password})

        return this
    }

    clickLogin() {
        cy.contains("Login").click()
        return new LoginPage();
    }
}
