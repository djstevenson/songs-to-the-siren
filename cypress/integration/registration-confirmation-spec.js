/// <reference types="Cypress" />

import { UserFactory } from '../support/user-factory'

const newUser = new UserFactory('regconf');

context('Registration confirm/decline tests', () => {
    describe('New user confirms registration', () => {
        it('sees right notification, and is confirmed', () => {

            newUser
                .getNextRegisteredUser()
                .confirmRegistration()
                .assertIsConfirmed()
                .assertIsNotAdmin()
        })
    })

    describe('New user declines registration', () => {
        it('sees the right notification, and is deleted', () => {

            newUser
                .getNextRegisteredUser()
                .declineRegistration()
                .assertDeleted()
        })
    })

    describe('New user uses bad confirm request', () => {
        it('gets 404 not found', () => {

            newUser
                .getNextRegisteredUser()
                .badConfirmRegistration('key')

            cy.assertPageNotFound()
        })
    })

    describe('New user uses bad decline request', () => {
        it('gets 404 not found', () => {

            newUser
                .getNextRegisteredUser()
                .badDeclineRegistration('key')

            cy.assertPageNotFound()
        })
    })

})
