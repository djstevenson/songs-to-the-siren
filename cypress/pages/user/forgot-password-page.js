import { Public             } from '../../pages/public'
import { ForgotPasswordForm } from '../../forms/forgot-password-form'
import { LoginPage          } from '../../pages/user/login-page'

export class ForgotPasswordPage extends Public {
    pageUrl() {
        return '/user/forgot_name'
    }

    constructor() {
        super()
        this._form = new ForgotPasswordForm()
    }

    visit() {
        new LoginPage().clickForgotPasswordLink()
        return this;
    }


    forgotPassword(email) {
        this.getForm().enter({email: email})

        return this
    }

}
