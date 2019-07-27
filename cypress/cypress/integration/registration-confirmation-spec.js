/// <reference types="Cypress" />

import { UserFactory } from '../support/user-factory'

var newUser = new UserFactory('regconf')

describe('Registration confirm/decline tests', function() {
    describe('New user confirms registration', function() {
        it('sees right notification, and is confirmed', function() {

            newUser
                .getNextRegisteredUser()
                .confirmRegistration()
                .assertIsConfirmed()
                .assertIsNotAdmin()
        })
    })

    describe('New user declines registration', function() {
        it('sees the right notification, and is deleted', function() {

            newUser
                .getNextRegisteredUser()
                .declineRegistration()
                .assertDeleted()
        })
    })

    describe('New user uses bad confirmation request', function() {
        it('sees right notification, and is not confirmed', function() {

            newUser
                .getNextRegisteredUser()
                .badConfirmRegistration('key')

            cy.assertPageNotFound()
        })
    })
})
