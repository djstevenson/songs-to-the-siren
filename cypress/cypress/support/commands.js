import { TestEmailPage } from '../pages/test-email-page'
import { TestUserPage  } from '../pages/test-user-page'
import { callbackify } from 'util';

// Call via user->confirmRegistration()
Cypress.Commands.add('confirmUserRegistration', (user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .confirmRegistration()
        .assertFlash('Registration confirmed')
        .assertNotification('Registration confirmed', 'You have confirmed registration of this account.')
})

// Call via user->badConfirmRegistration()
Cypress.Commands.add('badConfirmUserRegistration', (type, user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .badConfirmRegistration(type)
})

// Call via user->declineRegistration()
Cypress.Commands.add('declineUserRegistration', (user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .declineRegistration()
        .assertFlash('Registration declined')
        .assertNotification('Registration declined', 'You have declined registration of this account.')
})

// Call via user->badDeclineRegistration()
Cypress.Commands.add('badDeclineUserRegistration', (type, user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .badDeclineRegistration(type)
})

// Call via user->assertIsConfirmed()
Cypress.Commands.add('assertUserIsConfirmed', (user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsConfirmed()
})

// Call via user->assertIsNotConfirmed()
Cypress.Commands.add('assertUserIsNotConfirmed', (user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsNotConfirmed()
})

// Call via user->assertIsAdmin()
Cypress.Commands.add('assertUserIsAdmin', (user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsAdmin()
})

// Call via user->assertIsNotAdmin()
Cypress.Commands.add('assertUserIsNotAdmin', (user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsNotAdmin()
})

// Call via user->assertDeleted()
Cypress.Commands.add('assertUserDoesNotExist', (user) => {
    new TestUserPage()
        .assertNoUser(user.getName())
})

// Call after a click() etc to assert that the result is a 404 not found.
Cypress.Commands.add('assertPageNotFound', { prevSubject: 'optional' }, (subject) => {
    cy.get('div.page-not-found')
})

// Call via user->assertHasEmail('name_reminder')
Cypress.Commands.add('assertUserHasEmail', (user, type) => {
    new TestEmailPage()
        .visit(type, user.getName())

    cy  .get('td#email-email-to').contains(user.getEmail())
        .get('td#email-template-name').contains(type)
})

// Call via user->assertHasNoNameReminderEmail()
Cypress.Commands.add('assertUserHasNoEmail', (user, type) => {
    new TestEmailPage()
        .visit(type, user.getName())
    cy.get('div#email-not-found')
})
