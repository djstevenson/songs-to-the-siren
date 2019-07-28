/// <reference types="Cypress" />

import { UserFactory        } from '../support/user-factory'
import { ForgotPasswordPage } from '../pages/forgot-password-page'
import { ResetPasswordPage  } from '../pages/reset-password-page'
import { TestEmailPage      } from '../pages/test-email-page'
import { LoginPage } from '../pages/login-page';

var newUser = new UserFactory('pwresetconf')

describe('Password reset confirmation (and declination)', function() {
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
    
})
