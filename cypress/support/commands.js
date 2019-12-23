import { TestEmailPage } from '../pages/test-email-page'
import { TestUserPage  } from '../pages/test-user-page'
import { UserFactory   } from './user-factory'

const newUser = new UserFactory('commands');

// Call via user->confirmRegistration()
Cypress.Commands.add('confirmUserRegistration', (user) => {
    new TestEmailPage('registration', user.getName())
        .visit()
        .confirmRegistration()
        .assertFlash('Signup confirmed')
        .assertNotification('Signup confirmed', 'You have confirmed your signup.')
})

// Call via user->badConfirmRegistration()
Cypress.Commands.add('badConfirmUserRegistration', (type, user) => {
    new TestEmailPage('registration', user.getName())
        .visit()
        .badConfirmRegistration(type)
})

// Call via user->declineRegistration()
Cypress.Commands.add('declineUserRegistration', (user) => {
    new TestEmailPage('registration', user.getName())
        .visit()
        .declineRegistration()
        .assertFlash('Signup declined')
        .assertNotification('Signup declined', 'You have declined the signup of this account.')
})

// Call via user->badDeclineRegistration()
Cypress.Commands.add('badDeclineUserRegistration', (type, user) => {
    new TestEmailPage('registration', user.getName())
        .visit()
        .badDeclineRegistration(type)
})

// Call via user->assertIsConfirmed()
Cypress.Commands.add('assertUserIsConfirmed', (user) => {
    new TestUserPage(user.getName())
        .visit()
        .assertIsConfirmed()
})

// Call via user->assertIsNotConfirmed()
Cypress.Commands.add('assertUserIsNotConfirmed', (user) => {
    new TestUserPage(user.getName())
        .visit()
        .assertIsNotConfirmed()
})

// Call via user->assertIsAdmin()
Cypress.Commands.add('assertUserIsAdmin', (user) => {
    new TestUserPage(user.getName())
        .visit()
        .assertIsAdmin()
})

// Call via user->assertIsNotAdmin()
Cypress.Commands.add('assertUserIsNotAdmin', (user) => {
    new TestUserPage(user.getName())
        .visit()
        .assertIsNotAdmin()
})

// Call via user->assertDeleted()
Cypress.Commands.add('assertUserDoesNotExist', (user) => {
    new TestUserPage(user.getName())
        .assertNoUser()
})

// Call after a click() etc to assert that the result is a 404 not found.
Cypress.Commands.add('assertPageNotFound', { prevSubject: 'optional' }, (subject) => {
    cy.get('div.page-not-found')
})

// Call via user->assertHasEmail('name_reminder')
Cypress.Commands.add('assertUserHasEmail', (user, type) => {
    const page = new TestEmailPage(type, user.getName())
        .visit()

    cy  .get('td#email-email-to').contains(user.getEmail())
        .get('td#email-template-name').contains(type)
})

// Call via user->assertHasNoNameReminderEmail()
Cypress.Commands.add('assertUserHasNoEmail', (user, type) => {
    new TestEmailPage(type, user.getName())
        .assertVisitError(404)
})

// TODO Will need to trigger events if any code relies on them
//      Source: https://github.com/cypress-io/cypress/issues/566
Cypress.Commands.add('fill', {
    prevSubject: 'element'
}, (subject, value) => {
    cy.wrap(subject).invoke('val', value)
});

Cypress.Commands.add('publishSong', (title, flag) => {

    const url = '/test/publish_song'
        
    cy.request({
        url,
        method: 'POST',
        qs: {
            title,
            published:   (flag ? 1 : 0),
        }
    })
})

Cypress.Commands.add('resetDatabase', () => {

    cy.request({
        url: '/test/reset',
        method: 'POST'
    })
})

Cypress.Commands.add('signOut', () => {

    cy.request({
        url: '/user/sign_out',
        method: 'GET'
    })
})



