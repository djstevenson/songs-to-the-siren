import { Common } from '../pages/common'
import { ForgotNameForm } from '../forms/forgot-name-form'

export class ForgotNamePage extends Common {
    constructor() {
        super()
        this._form = new ForgotNameForm()
    }

    visit() {
        // TODO global config for base test URL
        cy.visit('http://localhost:3000/user/forgot_name')
        return this;
    }

    forgotName(email) {
        this.getForm().enter(new Map([['email', email]]))

        return this
    }

}
