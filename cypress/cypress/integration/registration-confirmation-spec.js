/// <reference types="Cypress" />

import { TestEmailPage } from '../pages/test-email-page'
import { UserFactory   } from '../support/user-factory'
import { TestUserPage } from '../pages/test-user-page'

var userFactory = new UserFactory('regconf')

describe('Registration confirm/decline tests', function() {
    describe('New user confirms registration', function() {
        it('sees the right notification', function() {

            // TODO Replace this with a Cypress custom "command"
            //      see https://til.hashrocket.com/posts/92ienlwv9z-custom-cypress-commands
            const { user, page } = userFactory.getNextRegistered()

            page
                .visit()
                .register(user.getName(), user.getBadEmail(), user.getPassword())
            
            new TestEmailPage()
                .visit('registration', user.getName())
                .confirmRegistration()
                .assertFlash('Registration confirmed')
                .assertNotification('You have confirmed registration of this account.')

            // User now confirmed
            new TestUserPage()
                .visit(user.getName())
                .assertIsConfirmed()
                .assertIsNotAdmin()
        })
    })
})
