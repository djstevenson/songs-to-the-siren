import { Public             } from '../pages/public'
import { ForgotPasswordForm } from '../forms/forgot-password-form'
import { LoginPage          } from '../pages/login-page'

export class ForgotPasswordPage extends Public {
    constructor() {
        super()
        this._form = new ForgotPasswordForm()
    }

    visit() {
        new LoginPage().clickForgotPasswordLink()
        return this;
    }


    forgotPassword(email) {
        this.getForm().enter(new Map([['email', email]]))

        return this
    }

}
