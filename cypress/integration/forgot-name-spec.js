/// <reference types="Cypress" />

import { ForgotNamePage } from '../pages/user/forgot-name-page'
import { UserFactory  } from '../support/user-factory'

const newUser = new UserFactory('forgotname');

context('Forgot-name form tests', () => {
    describe('Forgot-name form validation', () => {
        it('empty form returns right error', () => {

            new ForgotNamePage()
                .visit()
                .forgotName('')
                .assertFormError('email', 'Required')
        })

        it('invalid email returns right error a@a', () => {

            new ForgotNamePage()
                .visit()
                .forgotName('a@a')
                .assertFormError('email', 'Invalid email address')
        })

        it('invalid email returns right error xyzzy', () => {

            new ForgotNamePage()
                .visit()
                .forgotName('xyzzy')
                .assertFormError('email', 'Invalid email address')
        })
    })

    describe('User forgets password', () => {
        it('enters correct address, gets good response page, and email', () => {

            const user = newUser.getNextConfirmedUser()

            new ForgotNamePage()
                .visit()
                .forgotName(user.getEmail())
                .assertFlash('Name reminder')
                .assertNotification('Name reminder', 'If there is a user with that email address, a login name reminder has been sent by email.')

            user.assertHasEmail('name_reminder')
        })

        it('enters incorrect address, gets good response page, but no email', () => {

            const user = newUser.getNextConfirmedUser()

            new ForgotNamePage()
                .visit()
                .forgotName(user.getBadEmail())
                .assertFlash('Name reminder')
                .assertNotification('Name reminder', 'If there is a user with that email address, a login name reminder has been sent by email.')

            user.assertHasNoEmail('name_reminder')
        })
    })
})
