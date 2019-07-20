/// <reference types="Cypress" />

import { LoginPage    } from '../pages/login-page'
import { RegisterPage } from '../pages/register-page'

describe('Login tests', function() {
    describe('Login page looks right', function() {
        it('has the right title', function() {
            new LoginPage()
                .visit()
                .assertTitle('Login')
        })
    })

    // Tests incomplete...
    describe('Login form has field validation', function() {
        it('empty form shows "required" errors', function() {
            new LoginPage()
                .visit()
                .login('', '')
                .assertNameError('Required')
                .assertPasswordError('Required')
        })
        it('short username shows min-length error', function() {
            new LoginPage()
                .visit()
                .login('a', '')
                .assertNameError('Minimum length 3')
                .assertPasswordError('Required')
        })
        it('short username/password shows min-length errors', function() {
            new LoginPage()
                .visit()
                .login('a', 'b')
                .assertNameError('Minimum length 3')
                .assertPasswordError('Minimum length 5')
        })
        // TODO Do these commented-out tests make sense, cos it's not how the screen currently works
        // TODO The issue is that we try a login even when the fields have failed validation. Fix this.
        it('ok username, short password, only shows error for password', function() {
            new LoginPage()
                .visit()
                .login('abcdef', 'x')
                .assertNoNameError()
                .assertPasswordError('Minimum length 5')
        })
        it('short username, ok password, only shows error for username', function() {
            new LoginPage()
                .visit()
                .login('ab', 'xyzzy')
                .assertNameError('Minimum length 3')
                .assertNoPasswordError()
        })
    })

    describe('Login with good username/password succeeds', function() {
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

    describe('Logins with bad credentials fail', function() {
        it('shows right error on login attempt with wrong username', function() {
            new LoginPage()
                .visit()
                .login('logintest2', 'xyzzy')
                .assertNameError('Name and/or password incorrect')
                .assertLoggedOut()

        })
        it('shows right error on login attempt with wrong password', function() {
            new LoginPage()
                .visit()
                .login('logintest1', 'xyzzy2')
                .assertNameError('Name and/or password incorrect')
                .assertLoggedOut()

        })
        it('shows right error on login attempt with wrong username AND password', function() {
            new LoginPage()
                .visit()
                .login('logintest2', 'xyzzy2')
                .assertNameError('Name and/or password incorrect')
                .assertLoggedOut()

        })
    })
})
