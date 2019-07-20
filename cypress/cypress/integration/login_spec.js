/// <reference types="Cypress" />

import { LoginPage    } from '../pages/login-page'
import { RegisterPage } from '../pages/register-page'

describe('Login tests', function() {
    describe('Login page looks right', function() {
        it('has the right title', function() {
            const page = new LoginPage()
            page.visit()
                .assertTitle('Login')
        })
    })

    describe('Empty login form', function() {
        it('shows the right errors', function() {
            const page = new LoginPage()
            page.visit()
                .login('', '')
                .assertNameError('Required')
                .assertPasswordError('Required')
        })
    })

    describe('Login form with too-short name', function() {
        it('shows the right errors', function() {
            new LoginPage()
                .visit()
                .login('a', '')
                .assertNameError('Minimum length 3')
                .assertPasswordError('Required')
        })
    })

    describe('Login form with too-short name and password', function() {
        it('shows the right errors', function() {
            new LoginPage()
                .visit()
                .login('a', 'b')
                .assertNameError('Minimum length 3')
                .assertPasswordError('Minimum length 5')
        })
    })

    describe('Login with bad username fails', function() {
        it('shows right error on login attempt', function() {
            new RegisterPage()
                .visit()
                .register('logintest1', 'logintest1@example.com', 'xyzzy')
            
            new LoginPage()
                .visit()
                .login('logintest1', 'xyzzy')
                .assertLoggedInAs('logintest1')

        })
    })
})
