import { Public } from '../pages/public'
import { LoginForm } from '../forms/login-form'

export class LoginPage extends Public {
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
        cy.contains('Sign up to add comments').click()
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
