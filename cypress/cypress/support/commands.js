import { TestEmailPage } from '../pages/test-email-page'
import { TestUserPage  } from '../pages/test-user-page'

Cypress.Commands.add('confirmUserRegistration', {
  prevSubject: 'optional'
}, (subject, user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .confirmRegistration()
        .assertFlash('Registration confirmed')
        .assertNotification('You have confirmed registration of this account.')

    if (subject) {
        cy.wrap(subject)
    }
})

Cypress.Commands.add('declineUserRegistration', {
  prevSubject: 'optional'
}, (subject, user) => {
    new TestEmailPage()
        .visit('registration', user.getName())
        .declineRegistration()
        .assertFlash('Registration declined')
        .assertNotification('You have declined registration of this account.')

    if (subject) {
        cy.wrap(subject)
    }
})

Cypress.Commands.add('assertUserIsConfirmed', {
  prevSubject: 'optional'
}, (subject, user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsConfirmed()

    if (subject) {
        cy.wrap(subject)
    }
})

Cypress.Commands.add('assertUserIsNotAdmin', {
  prevSubject: 'optional'
}, (subject, user) => {
    new TestUserPage()
        .visit(user.getName())
        .assertIsNotAdmin()

    if (subject) {
        cy.wrap(subject)
    }
})

Cypress.Commands.add('assertUserDoesNotExist', {
    prevSubject: 'optional'
  }, (subject, user) => {
      new TestUserPage()
        .assertNoUser(user.getName())
  
      if (subject) {
          cy.wrap(subject)
      }
  })
  