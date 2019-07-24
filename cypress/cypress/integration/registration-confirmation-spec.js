/// <reference types="Cypress" />

import { TestEmailPage } from '../pages/test-email-page'
import { UserFactory   } from '../support/user-factory'

var userFactory = new UserFactory('regconf')

describe('Registration confirm/decline tests', function() {
    describe('New user confirms registration', function() {
        it('sees the right notification', function() {
            const { user, page } = userFactory.getNextRegistered()

            page
                .visit()
                .register(user.getName(), user.getBadEmail(), user.getPassword())
            
            new TestEmailPage()
                .visit('registration', user.getName());
        })
    })
})
