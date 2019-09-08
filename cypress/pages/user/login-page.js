import { Public    } from '../public'
import { LoginForm } from '../../forms/login-form'

export class LoginPage extends Public {
    pageUrl() {
        return '/user/login'
    }

    constructor() {
        super()
        this._form = new LoginForm()
    }

    login(name, password) {
        this.getForm().enter({name, password})

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
