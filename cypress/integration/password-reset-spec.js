/// <reference types="Cypress" />

import { UserFactory       } from '../support/user-factory'
import { ResetPasswordPage } from '../pages/user/reset-password-page'

var newUser = new UserFactory('pwresetconf')

describe('Password reset confirmation', () => {
    describe('User can perform successful reset', () => {
        it('reset-confirm shows right shiz', () => {

            const user = newUser
                .getNextConfirmedUser()
            
            user
                .requestPasswordReset()
                .confirmReset()
                .assertLoggedOut()
            
            const newPassword = 'x' + user.getPassword()

            const resetPage = new ResetPasswordPage()
                .resetPassword(newPassword)
                .assertFlash('Your password has been reset')
                .assertNotification('Password reset', 'Your password has been reset.')
            
            // Finally, login with the new password
            resetPage.clickLogin()
                .visit()
                .login(user.getName(), newPassword)
                .assertLoggedInAs(user.getName())

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
