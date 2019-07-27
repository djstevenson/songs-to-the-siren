import { Common } from '../pages/common'
import { RegisterForm } from '../forms/register-form'

export class RegisterPage extends Common {
    constructor() {
        super()
        this._form = new RegisterForm()
    }

    visit() {
        // TODO global config for base test URL
        cy.visit('/user/register')
        return this;
    }

    register(name, email, password) {
        this.getForm().enter(new Map([['name', name], ['email', email], ['password', password]]))

        return this
    }

}
