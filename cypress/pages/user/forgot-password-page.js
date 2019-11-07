import { Public             } from '../public'
import { ForgotPasswordForm } from '../../forms/forgot-password-form'
import { SignInPage         } from './sign-in-page'

export class ForgotPasswordPage extends Public {
    pageUrl() {
        return '/user/forgot_name'
    }

    constructor() {
        super()
        this._form = new ForgotPasswordForm()
    }

    visit() {
        new SignInPage().clickForgotPasswordLink()
        return this;
    }


    forgotPassword(email) {
        this.getForm().enter({email})

        return this
    }

}
