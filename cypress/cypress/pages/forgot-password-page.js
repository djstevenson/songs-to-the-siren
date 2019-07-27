import { Common } from '../pages/common'
import { ForgotPasswordForm } from '../forms/forgot-password-form'

export class ForgotPasswordPage extends Common {
    constructor() {
        super()
        this._form = new ForgotPasswordForm()
    }

    visit() {
        // TODO global config for base test URL
        cy.visit('http://localhost:3000/user/forgot_password')
        return this;
    }

    forgotPassword(email) {
        this.getForm().enter(new Map([['email', email]]))

        return this
    }

}
