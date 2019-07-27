/// <reference types="Cypress" />

import { ForgotNamePage } from '../pages/forgot-name-page'
import { UserFactory  } from '../support/user-factory'

var newUser = new UserFactory('regconf')

describe('Forgot-name form tests', function() {
    describe('Forgot-name form validation', function() {
        it('empty form returns right error', function() {

            new ForgotNamePage()
                .visit()
                .forgotName('')
                .assertFormError('email', 'Required')
        })

        it('invalid email returns right error a@a', function() {

            new ForgotNamePage()
                .visit()
                .forgotName('a@a')
                .assertFormError('email', 'Invalid email address')
        })

        it('invalid email returns right error xyzzy', function() {

            new ForgotNamePage()
                .visit()
                .forgotName('xyzzy')
                .assertFormError('email', 'Invalid email address')
        })
    })

    describe('User forgets password', function() {
        it('enters correct email, and gets good response page', function() {

            const user = newUser.getNextRegisteredUser()

            new ForgotNamePage()
                .visit()
                .forgotName(user.getEmail())
                .assertFlash('Name reminder')
                .assertNotification('If there is a user with that email address, a login name reminder has been sent by email.')
            
            user.assertHasNameReminderEmail()
        })
    })

    // describe('New user uses bad confirm request', function() {
    //     it('gets 404 not found', function() {

    //         newUser
    //             .getNextRegisteredUser()
    //             .badConfirmRegistration('key')

    //         cy.assertPageNotFound()
    //     })
    // })

    // describe('New user uses bad decline request', function() {
    //     it('gets 404 not found', function() {

    //         newUser
    //             .getNextRegisteredUser()
    //             .badDeclineRegistration('key')

    //         cy.assertPageNotFound()
    //     })
    // })

})
