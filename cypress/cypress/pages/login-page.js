import { Common } from '../pages/common'
import { LoginForm } from '../forms/login-form'

export class LoginPage extends Common {
    constructor() {
        super()
        this._form = new LoginForm()
    }

    visit() {
        // TODO global config for base test URL
        cy.visit('http://localhost:3000/user/login')
        return this
    }

    login(name, password) {
        this.getForm().enter(new Map([['name', name], ['password', password]]))

        return this
    }

}
