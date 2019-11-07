/// <reference types="Cypress" />

import { UserFactory       } from '../support/user-factory'
import { ResetPasswordPage } from '../pages/user/reset-password-page'

const newUser = new UserFactory('pwresetconf');

context('Password reset confirmation', () => {
    describe('User can perform successful reset', () => {
        it('reset-confirm shows right shiz', () => {

            const user = newUser
                .getNextConfirmedUser()
            
            user
                .requestPasswordReset()
                .confirmReset()
                .assertSignedOut()
            
            const oldPassword = user.getPassword()
            const newPassword = `x${oldPassword}`

            const resetPage = new ResetPasswordPage()
                .resetPassword(newPassword)
                .assertFlash('Your password has been reset')
                .assertNotification('Password reset', 'Your password has been reset.')
            
            // Finally, sign in with the new password
            resetPage.clickSignIn()
                .visit()
                .signIn(user.getName(), newPassword)
                .assertSignedInAs(user.getName())

        })
    })
    
    describe('Invalid reset requests are rejected', () => {
        it('invalid reset code gives page-not-found', () => {

            newUser
                .getNextConfirmedUser()
                .requestPasswordReset()
                .badConfirmReset()
            
            cy.assertPageNotFound()

        })
    })
    
    describe('Invalid new passwords are rejected', () => {
        it('bad new passwords give right errors', () => {

            const user = newUser
                .getNextConfirmedUser()
                .requestPasswordReset()
                .confirmReset()
            
            new ResetPasswordPage()
                .resetPassword('').assertFormError('password', 'Required')
                .resetPassword('abc').assertFormError('password', 'Minimum length 5')
        })
    })
    
})
