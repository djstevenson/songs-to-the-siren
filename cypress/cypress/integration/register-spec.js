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
                .assertTitle('Register')
        })
    })

    describe('Register form has field validation', function() {
        it('empty form shows "required" errors', function() {
            new RegisterPage()
                .visit()
                .register('', '', '')
                .assertNameError('Required')
                .assertEmailError('Required')
                .assertPasswordError('Required')
        })
        it('short username shows min-length error', function() {
            new RegisterPage()
                .visit()
                .register('a', '', '')
                .assertNameError('Minimum length 3')
                .assertEmailError('Required')
                .assertPasswordError('Required')
        })
        it('short username/password shows min-length errors', function() {
            new RegisterPage()
                .visit()
                .register('a', 'b@example.com', 'c')
                .assertNameError('Minimum length 3')
                .assertNoEmailError()
                .assertPasswordError('Minimum length 5')
        })
        it('invalid email shows appropriate error', function() {
            new RegisterPage()
                .visit()
                .register('aaaaaa', 'me', 'xxxxxx')
                .assertNoNameError()
                .assertEmailError('Invalid email address')
                .assertNoPasswordError()
        })
        it('Name aleady-in-use is rejected', function() {
            // Do a good reg
            let { user, page } = userFactory.getNextRegistered()

            // And try to re-use the name
            page
                .visit()
                .register(user.getName(), user.getBadEmail(), user.getPassword())
                .assertNameError('Name already in use')
                .assertNoEmailError()
                .assertNoPasswordError()
        })
        it('Password aleady-in-use is rejected', function() {
            // Do a good reg
            let { user, page } = userFactory.getNextRegistered()

            // And try to re-use the email
            page
                .visit()
                .register(user.getBadName(), user.getEmail(), user.getPassword())
                .assertNoNameError()
                .assertEmailError('Email already registered')
                .assertNoPasswordError()
        })
    })

    describe('Register with good details succeeds', function() {
        it('registering does not login user', function() {
            userFactory.getNextRegistered()['page']
                .assertLoggedOut();
        })
        it('registering shows a "success" response', function() {
            userFactory.getNextRegistered()['page']
                .assertFlash('Registered - watch out for confirmation email')
                .assertNotification('Thank you for your registration request.')
        })
        it('registered user can login ok', function() {
            let user = userFactory.getNextRegistered()['user']

            new LoginPage()
                .visit()
                .login(user.getName(), user.getPassword())
                .assertLoggedInAs(user.getName())
        })

        // Testing for what I user can do before/after they confirm
        // registration will be done in other tests e.g. the comments tests
    })
})
