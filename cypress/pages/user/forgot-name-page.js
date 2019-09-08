import { Public         } from '../public'
import { ForgotNameForm } from '../../forms/forgot-name-form'
import { LoginPage      } from './login-page'

export class ForgotNamePage extends Public {
    pageUrl() {
        return '/user/forgot_name'
    }

    constructor() {
        super()
        this._form = new ForgotNameForm()
    }

    visit() {
        new LoginPage().clickForgotNameLink()
        return this;
    }

    forgotName(email) {
        this.getForm().enter({email})

        return this
    }

}
