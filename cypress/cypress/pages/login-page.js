import { Common } from '../pages/common'
import { LoginForm } from '../forms/login-form'

export class LoginPage extends Common {
    constructor() {
        super()
        this._form = new LoginForm()
    }

    visit() {
        cy.visit('/user/login')
        return this
    }

    login(name, password) {
        this.getForm().enter(new Map([['name', name], ['password', password]]))

        return this
    }


    clickRegisterLink() {
        this.visit()
        cy.contains('Register new account').click()
    }

    clickForgotNameLink() {
        this.visit()
        cy.contains('Forgot user name').click()
    }

    clickForgotPasswordLink() {
        this.visit()
        cy.contains('Forgot password').click()
    }
}
