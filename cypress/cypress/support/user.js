var reverse = require('reverse-string')

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

    assertHasNameReminderEmail() {
        cy.assertUserHasNameReminderEmail(this)
        return this
    }

    assertHasNoNameReminderEmail() {
        cy.assertUserHasNoNameReminderEmail(this)
        return this
    }
}

