/// <reference types="Cypress" />

import { LoginPage    } from '../pages/user/login-page'
import { UserFactory  } from '../support/user-factory'

var userFactory = new UserFactory('logintest')

describe('Login tests', () => {
    describe('Login page looks right', () => {
        it('has the right title', () => {
            new LoginPage()
                .visit()
                .assertTitle('Login')
        })
    })

    describe('Login form has field validation', () => {
        it('empty form shows "required" errors', () => {
            new LoginPage()
                .visit()
                .login('', '')
                .assertFormError('name', 'Required')
                .assertFormError('password', 'Required')
        })
        it('short username shows min-length error', () => {
            new LoginPage()
                .visit()
                .login('a', '')
                .assertFormError('name', 'Minimum length 3')
                .assertFormError('password', 'Required')
        })
        it('short username/password shows min-length errors', () => {
            new LoginPage()
                .visit()
                .login('a', 'b')
                .assertFormError('name', 'Minimum length 3')
                .assertFormError('password', 'Minimum length 5')
        })
        it('ok username, short password, only shows error for password', () => {
            new LoginPage()
                .visit()
                .login('abcdef', 'x')
                .assertNoFormError('name')
                .assertFormError('password', 'Minimum length 5')
        })
        it('short username, ok password, only shows error for username', () => {
            new LoginPage()
                .visit()
                .login('ab', 'xyzzy')
                .assertFormError('name', 'Minimum length 3')
                .assertNoFormError('password')
        })
    })

    describe('Login with good username/password succeeds', () => {
        it('logs in and shows right login status', () => {
            const user = userFactory.getNextRegisteredUser()
            
            new LoginPage()
                .visit()
                .login(user.getName(), user.getPassword())
                .assertLoggedInAs(user.getName())

        })
    })

    describe('Logins with bad credentials fail', () => {
        it('shows right error on login attempt with wrong username', () => {
            const user = userFactory.getNextRegisteredUser()

            new LoginPage()
                .visit()
                .login(user.getBadName(), user.getPassword())
                .assertFormError('name', 'Name and/or password incorrect')
                .assertLoggedOut()

        })
        it('shows right error on login attempt with wrong password', () => {
            const user = userFactory.getNextRegisteredUser()

            new LoginPage()
                .visit()
                .login(user.getName(), user.getBadPassword())
                .assertFormError('name', 'Name and/or password incorrect')
                .assertLoggedOut()

        })
        it('shows right error on login attempt with wrong username AND password', () => {
            const user = userFactory.getNextRegisteredUser()

            new LoginPage()
                .visit()
                .login(user.getBadName(), user.getBadPassword())
                .assertFormError('name', 'Name and/or password incorrect')
                .assertLoggedOut()

        })
    })
})
