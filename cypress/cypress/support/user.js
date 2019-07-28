var reverse = require('reverse-string')

import { TestEmailPage      } from '../pages/test-email-page'
import { ForgotPasswordPage } from '../pages/forgot-password-page'

export class User {
    constructor(baseName) {
        this._name = baseName
        this._email = this._name + "@example.com"
        this._password = "PW " + reverse(this._name)
    }

    getName() {
        return this._name
    }

    getBadName() {
        return this._name + 'a'
    }

    getEmail() {
        return this._email
    }

    getBadEmail() {
        return 'e' + this._email
    }

    getPassword() {
        return this._password
    }

    getBadPassword() {
        return this._password + 'x'
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

    assertHasNoEmail(type) {
        cy.assertUserHasNoEmail(this, type)
        return this
    }

    // Returns a TestEmailPage from which you can click to confirm reset
    requestPasswordReset() {
        new ForgotPasswordPage()
            .visit()
            .forgotPassword(this.getEmail())

        return new TestEmailPage()
            .visit('password_reset', this.getName())

    }
}

