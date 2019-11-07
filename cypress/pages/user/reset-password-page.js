import { Public            } from '../public'
import { ResetPasswordForm } from '../../forms/reset-password-form'
import { SignInPage        } from './sign-in-page';

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
        return new SignInPage();
    }
}
