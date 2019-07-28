/// <reference types="Cypress" />

import { UserFactory        } from '../support/user-factory'
import { ForgotPasswordPage } from '../pages/forgot-password-page'
import { ResetPasswordPage  } from '../pages/reset-password-page'
import { TestEmailPage      } from '../pages/test-email-page'
import { LoginPage } from '../pages/login-page';

var newUser = new UserFactory('pwresetconf')

describe('Password reset confirmation', function() {
    describe('User can perform successful reset', function() {
        it('reset-confirm shows right shiz', function() {

            const user = newUser
                .getNextRegisteredUser()
                .confirmRegistration()
            
            new ForgotPasswordPage()
                .visit()
                .forgotPassword(user.getEmail())

            new TestEmailPage()
                .visit('password_reset', user.getName())
                .confirmReset()
                .assertLoggedOut()
            
            const newPassword = 'x' + user.getPassword();
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

            const user = newUser
                .getNextRegisteredUser()
                .confirmRegistration()
            
            new ForgotPasswordPage()
                .visit()
                .forgotPassword(user.getEmail())

            new TestEmailPage()
                .visit('password_reset', user.getName())
                .badConfirmReset()
            
            cy.assertPageNotFound()

        })
    })
    
    describe('Invalid new passwords are rejected', function() {
        it('bad new passwords give right errors', function() {

            const user = newUser
                .getNextRegisteredUser()
                .confirmRegistration()
            
            new ForgotPasswordPage()
                .visit()
                .forgotPassword(user.getEmail())

            new TestEmailPage()
                .visit('password_reset', user.getName())
                .confirmReset()
            
            new ResetPasswordPage()
                .resetPassword('').assertFormError('password', 'Required')
                .resetPassword('abc').assertFormError('password', 'Minimum length 5')
        })
    })
    
})
