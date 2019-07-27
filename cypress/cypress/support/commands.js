import { TestEmailPage } from '../pages/test-email-page'
import { TestUserPage  } from '../pages/test-user-page'

// Call via user->confirmRegistration()
Cypress.Commands.add('confirmUserRegistration', { prevSubject: 'optional' }, (subject, user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .confirmRegistration()
        .assertFlash('Registration confirmed')
        .assertNotification('You have confirmed registration of this account.')

    if (subject) {
        cy.wrap(subject)
    }
})

// Call via user->badConfirmRegistration()
Cypress.Commands.add('badConfirmUserRegistration', { prevSubject: 'optional' }, (subject, type, user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .badConfirmRegistration(type)

    if (subject) {
        cy.wrap(subject)
    }
})

// Call via user->declineRegistration()
Cypress.Commands.add('declineUserRegistration', { prevSubject: 'optional' }, (subject, user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .declineRegistration()
        .assertFlash('Registration declined')
        .assertNotification('You have declined registration of this account.')

    if (subject) {
        cy.wrap(subject)
    }
})

// Call via user->assertIsConfirmed()
Cypress.Commands.add('assertUserIsConfirmed', { prevSubject: 'optional' }, (subject, user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsConfirmed()

    if (subject) {
        cy.wrap(subject)
    }
})

// Call via user->assertIsNotConfirmed()
Cypress.Commands.add('assertUserIsNotConfirmed', { prevSubject: 'optional' }, (subject, user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsNotConfirmed()

    if (subject) {
        cy.wrap(subject)
    }
})

// Call via user->assertIsAdmin()
Cypress.Commands.add('assertUserIsAdmin', { prevSubject: 'optional' }, (subject, user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsAdmin()

    if (subject) {
        cy.wrap(subject)
    }
})

// Call via user->assertIsNotAdmin()
Cypress.Commands.add('assertUserIsNotAdmin', { prevSubject: 'optional' }, (subject, user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsNotAdmin()

    if (subject) {
        cy.wrap(subject)
    }
})

// Call via user->assertDeleted()
Cypress.Commands.add('assertUserDoesNotExist', { prevSubject: 'optional' }, (subject, user) => {
    new TestUserPage()
     .assertNoUser(user.getName())

    if (subject) {
        cy.wrap(subject)
    }
})

// Call after a click() etc to assert that the result is a 404 not found.
Cypress.Commands.add('assertPageNotFound', { prevSubject: 'optional' }, (subject) => {
    cy.get('div.page-not-found')

    if (subject) {
        cy.wrap(subject)
    }
})
