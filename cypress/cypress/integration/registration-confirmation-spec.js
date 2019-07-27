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

    describe('New user uses bad confirm request', function() {
        it('gets 404 not found', function() {

            newUser
                .getNextRegisteredUser()
                .badConfirmRegistration('key')

            cy.assertPageNotFound()
        })
    })

    describe('New user uses bad decline request', function() {
        it('gets 404 not found', function() {

            newUser
                .getNextRegisteredUser()
                .badDeclineRegistration('key')

            cy.assertPageNotFound()
        })
    })

})
