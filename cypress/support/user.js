import reverse from 'reverse-string';

import { TestEmailPage      } from '../pages/test-email-page'
import { ForgotPasswordPage } from '../pages/user/forgot-password-page'
import { SignInPage         } from '../pages/user/sign-in-page'

export class User {
    constructor(baseName, admin = false) {
        this._name = baseName
        this._email = `${baseName}@example.com`
        this._password = `PW ${reverse(baseName)}`
        this._admin = admin
    }

    getName() {
        return this._name
    }

    getBadName() {
        return `${this._name}a`;
    }

    getEmail() {
        return this._email
    }

    getBadEmail() {
        return `e${this._email}`;
    }

    getPassword() {
        return this._password
    }

    getBadPassword() {
        return `${this._password}x`;
    }

    confirmRegistration() {
        cy.confirmUserRegistration(this)
        return this
    }

    badConfirmRegistration(type) {
        cy.badConfirmUserRegistration(type, this)
        return this
    }

    declineRegistration() {
        cy.declineUserRegistration(this)
        return this
    }

    badDeclineRegistration(type) {
        cy.badDeclineUserRegistration(type, this)
        return this
    }

    assertIsConfirmed() {
        cy.assertUserIsConfirmed(this)
        return this
    }

    assertIsNotConfirmed() {
        cy.assertUserIsNotConfirmed(this)
        return this
    }

    assertIsAdmin() {
        cy.assertUserIsAdmin(this)
        return this
    }

    assertIsNotAdmin() {
        cy.assertUserIsNotAdmin(this)
        return this
    }

    assertDeleted() {
        cy.assertUserDoesNotExist(this)
        return this
    }

    assertHasEmail(type) {
        cy.assertUserHasEmail(this, type)
        return this
    }

    getEmailPage(type) {
        this.assertHasEmail(type)
        return new TestEmailPage(type, this.getName()).visit()
    }
    
    assertHasNoEmail(type) {
        cy.assertUserHasNoEmail(this, type)
        return this
    }

    // Returns a TestEmailPage from which you can click to confirm reset
    requestPasswordReset() {
        new ForgotPasswordPage()
            .visit()
            .forgotPassword(this.getEmail())

        return this.getEmailPage('password_reset')

    }

    signIn() {
        new SignInPage()
            .visit()
            .signIn(this.getName(), this.getPassword())

        return this
    }
}

