import { Public     } from '../public'
import { SignInForm } from '../../forms/sign-in-form'

export class SignInPage extends Public {
    pageUrl() {
        return '/user/sign_in'
    }

    constructor() {
        super()
        this._form = new SignInForm()
    }

    signIn(name, password) {
        this.getForm().enter({name, password})

        return this
    }


    clickRegisterLink() {
        this.visit()
        cy.contains('Sign up new account').click()
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
