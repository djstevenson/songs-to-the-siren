import { Public         } from '../public'
import { ForgotNameForm } from '../../forms/forgot-name-form'
import { SignInPage     } from './sign-in-page'

export class ForgotNamePage extends Public {
    pageUrl() {
        return '/user/forgot_name'
    }

    constructor() {
        super()
        this._form = new ForgotNameForm()
    }

    visit() {
        new SignInPage().clickForgotNameLink()
        return this;
    }

    forgotName(email) {
        this.getForm().enter({email})

        return this
    }

}
