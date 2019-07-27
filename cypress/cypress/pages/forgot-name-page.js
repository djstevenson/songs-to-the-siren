import { Common         } from '../pages/common'
import { ForgotNameForm } from '../forms/forgot-name-form'
import { LoginPage      } from '../pages/login-page'

export class ForgotNamePage extends Common {
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
