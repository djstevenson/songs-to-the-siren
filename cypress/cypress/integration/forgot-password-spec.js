/// <reference types="Cypress" />

import { ForgotPasswordPage } from '../pages/forgot-password-page'
import { UserFactory        } from '../support/user-factory'

var newUser = new UserFactory('forgotpasswd')

describe('Forgot-passworrd form tests', function() {
    describe('Forgot-password form validation', function() {
        it('empty form returns right error', function() {

            new ForgotPasswordPage()
                .visit()
                .forgotPassword('')
                .assertFormError('email', 'Required')
        })

        it('invalid email returns right error a@a', function() {

            new ForgotPasswordPage()
                .visit()
                .forgotPassword('a@a')
                .assertFormError('email', 'Invalid email address')
        })

        it('invalid email returns right error xyzzy', function() {

            new ForgotPasswordPage()
                .visit()
                .forgotPassword('xyzzy')
                .assertFormError('email', 'Invalid email address')
        })
    })

    describe('User forgets password', function() {
        it('enters correct address, gets good response page, and email', function() {

            const user = newUser.getNextConfirmedUser()

            new ForgotPasswordPage()
                .visit()
                .forgotPassword(user.getEmail())
                .assertFlash('Password reset email sent')
                .assertNotification('Password reset', 'If there is a user with that email address, a link has been sent by email which will allow resetting the password.')

            user.assertHasEmail('password_reset')
        })

        it('enters incorrect address, gets good response page, but no email', function() {

            const user = newUser.getNextConfirmedUser()

            new ForgotPasswordPage()
                .visit()
                .forgotPassword(user.getBadEmail())
                .assertFlash('Password reset email sent')
                .assertNotification('Password reset', 'If there is a user with that email address, a link has been sent by email which will allow resetting the password.')

                user.assertHasNoEmail('password_reset')
            })
    })
})
