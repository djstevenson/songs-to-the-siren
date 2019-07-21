/// <reference types="Cypress" />

import { LoginPage    } from '../pages/login-page'
import { UserFactory  } from '../support/user-factory'

var userFactory = new UserFactory('logintest')

describe('Login tests', function() {
    describe('Login page looks right', function() {
        it('has the right title', function() {
            new LoginPage()
                .visit()
                .assertTitle('Login')
        })
    })

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
        it('logs in and shows right login status', function() {
            const user = userFactory.getNextRegistered()['user']
            
            new LoginPage()
                .visit()
                .login(user.getName(), user.getPassword())
                .assertLoggedInAs(user.getName())

        })
    })

    describe('Logins with bad credentials fail', function() {
        it('shows right error on login attempt with wrong username', function() {
            const user = userFactory.getNextRegistered()['user']

            new LoginPage()
                .visit()
                .login(user.getBadName(), user.getPassword())
                .assertNameError('Name and/or password incorrect')
                .assertLoggedOut()

        })
        it('shows right error on login attempt with wrong password', function() {
            const user = userFactory.getNextRegistered()['user']

            new LoginPage()
                .visit()
                .login(user.getName(), user.getBadPassword())
                .assertNameError('Name and/or password incorrect')
                .assertLoggedOut()

        })
        it('shows right error on login attempt with wrong username AND password', function() {
            const user = userFactory.getNextRegistered()['user']

            new LoginPage()
                .visit()
                .login(user.getBadName(), user.getBadPassword())
                .assertNameError('Name and/or password incorrect')
                .assertLoggedOut()

        })
    })
})
