/// <reference types="Cypress" />

import { LoginPage    } from '../pages/login-page'
import { RegisterPage } from '../pages/register-page'
import { UserFactory  } from '../support/user-factory'

var userFactory = new UserFactory('regtest')

describe('Registration tests', function() {
    describe('Register page looks right', function() {
        it('has the right title', function() {
            new RegisterPage()
                .visit()
                .assertTitle('Sign up')
        })
    })

    describe('Register form has field validation', function() {
        it('empty form shows "required" errors', function() {
            new RegisterPage()
                .visit()
                .register('', '', '')
                .assertFormError('name', 'Required')
                .assertFormError('email', 'Required')
                .assertFormError('password', 'Required')
        })
        it('short username shows min-length error', function() {
            new RegisterPage()
                .visit()
                .register('a', '', '')
                .assertFormError('name', 'Minimum length 3')
                .assertFormError('email', 'Required')
                .assertFormError('password', 'Required')
        })
        it('short username/password shows min-length errors', function() {
            new RegisterPage()
                .visit()
                .register('a', 'b@example.com', 'c')
                .assertFormError('name', 'Minimum length 3')
                .assertNoFormError('email')
                .assertFormError('password', 'Minimum length 5')
        })
        it('invalid email shows appropriate error', function() {
            new RegisterPage()
                .visit()
                .register('aaaaaa', 'me', 'xxxxxx')
                .assertNoFormError('name')
                .assertFormError('email', 'Invalid email address')
                .assertNoFormError('password')
        })
        it('Name aleady-in-use is rejected', function() {
            // Do a good reg
            const { user, page } = userFactory.getNextRegistered()

            // And try to re-use the name
            page
                .visit()
                .register(user.getName(), user.getBadEmail(), user.getPassword())
                .assertFormError('name', 'Name already in use')
                .assertNoFormError('email')
                .assertNoFormError('password')
        })
        it('Password aleady-in-use is rejected', function() {
            // Do a good reg
            const { user, page } = userFactory.getNextRegistered()

            // And try to re-use the email
            page
                .visit()
                .register(user.getBadName(), user.getEmail(), user.getPassword())
                .assertNoFormError('name')
                .assertFormError('email', 'Email already registered')
                .assertNoFormError('password')
        })
    })

    describe('Register with good details succeeds', function() {
        it('registering does not login user', function() {
            userFactory.getNextRegistered()['page']
                .assertLoggedOut();
        })
        it('registering shows a "success" response', function() {
            userFactory.getNextRegistered()['page']
                .assertFlash('User created - watch out for confirmation email')
                .assertNotification('New user created', 'Thank you for your signup request.')
        })
        it('registered user can login ok', function() {
            const user = userFactory.getNextRegisteredUser()

            new LoginPage()
                .visit()
                .login(user.getName(), user.getPassword())
                .assertLoggedInAs(user.getName())
        })
        it('registered user is not confirmed', function() {
            const user = userFactory.getNextRegisteredUser()

            user
                .assertIsNotConfirmed()
                .assertIsNotAdmin()
        })

        // Testing for what I user can do before/after they confirm
        // registration will be done in other tests e.g. the comments tests
    })
})
