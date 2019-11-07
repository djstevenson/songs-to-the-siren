/// <reference types="Cypress" />

import { SignInPage   } from '../pages/user/sign-in-page'
import { UserFactory  } from '../support/user-factory'

const userFactory = new UserFactory('signintest');

context('Sign in tests', () => {
    describe('Sign in page looks right', () => {
        it('has the right title', () => {
            new SignInPage()
                .visit()
                .assertTitle('Sign in')
        })
    })

    describe('Sign in form has field validation', () => {
        it('empty form shows "required" errors', () => {
            new SignInPage()
                .visit()
                .signIn('', '')
                .assertFormError('name', 'Required')
                .assertFormError('password', 'Required')
        })
        it('short username shows min-length error', () => {
            new SignInPage()
                .visit()
                .signIn('a', '')
                .assertFormError('name', 'Minimum length 3')
                .assertFormError('password', 'Required')
        })
        it('short username/password shows min-length errors', () => {
            new SignInPage()
                .visit()
                .signIn('a', 'b')
                .assertFormError('name', 'Minimum length 3')
                .assertFormError('password', 'Minimum length 5')
        })
        it('ok username, short password, only shows error for password', () => {
            new SignInPage()
                .visit()
                .signIn('abcdef', 'x')
                .assertNoFormError('name')
                .assertFormError('password', 'Minimum length 5')
        })
        it('short username, ok password, only shows error for username', () => {
            new SignInPage()
                .visit()
                .signIn('ab', 'xyzzy')
                .assertFormError('name', 'Minimum length 3')
                .assertNoFormError('password')
        })
    })

    describe('Sign in with good username/password succeeds', () => {
        it('logs in and shows right Sign in status', () => {
            const user = userFactory.getNextRegisteredUser()
            
            new SignInPage()
                .visit()
                .signIn(user.getName(), user.getPassword())
                .assertSignedInAs(user.getName())

        })
    })

    describe('Signs in with bad credentials fail', () => {
        it('shows right error on Sign in attempt with wrong username', () => {
            const user = userFactory.getNextRegisteredUser()

            new SignInPage()
                .visit()
                .signIn(user.getBadName(), user.getPassword())
                .assertFormError('name', 'Name and/or password incorrect')
                .assertSignedOut()

        })
        it('shows right error on Sign in attempt with wrong password', () => {
            const user = userFactory.getNextRegisteredUser()

            new SignInPage()
                .visit()
                .signIn(user.getName(), user.getBadPassword())
                .assertFormError('name', 'Name and/or password incorrect')
                .assertSignedOut()

        })
        it('shows right error on Sign in attempt with wrong username AND password', () => {
            const user = userFactory.getNextRegisteredUser()

            new SignInPage()
                .visit()
                .signIn(user.getBadName(), user.getBadPassword())
                .assertFormError('name', 'Name and/or password incorrect')
                .assertSignedOut()

        })
    })
})
