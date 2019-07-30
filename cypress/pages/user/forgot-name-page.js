import { Public         } from '../../pages/public'
import { ForgotNameForm } from '../../forms/forgot-name-form'
import { LoginPage      } from '../../pages/user/login-page'

export class ForgotNamePage extends Public {
    constructor() {
        super()
        this._form = new ForgotNameForm()
    }

    visit() {
        new LoginPage().clickForgotNameLink()
        return this;
    }

    forgotName(email) {
        this.getForm().enter(new Map([['email', email]]))

        return this
    }

}
