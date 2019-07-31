/// <reference types="Cypress" />

import { UserFactory       } from '../support/user-factory'
import { ResetPasswordPage } from '../pages/user/reset-password-page'

var newUser = new UserFactory('pwresetconf')

describe('Password reset confirmation', function() {
    describe('User can perform successful reset', function() {
        it('reset-confirm shows right shiz', function() {

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
    
    describe('Invalid reset requests are rejected', function() {
        it('invalid reset code gives page-not-found', function() {

            newUser
                .getNextConfirmedUser()
                .requestPasswordReset()
                .badConfirmReset()
            
            cy.assertPageNotFound()

        })
    })
    
    describe('Invalid new passwords are rejected', function() {
        it('bad new passwords give right errors', function() {

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
