/// <reference types="Cypress" />

import { LoginPage } from '../pages/login-page'

describe('Login tests', function() {
    describe('Login page looks right', function() {
        it('has the right title', function() {
            const login = new LoginPage();
            login.visit()
                .assertTitle('Login')
        })
    })

    describe('Empty login form', function() {
        it('shows the right errors', function() {
            const login = new LoginPage()
            login.visit()
                .login('', '')
                .assertNameError('Required')
                .assertPasswordError('Required')
        })
    })

    describe('Login form with too-short name', function() {
        it('shows the right errors', function() {
            const login = new LoginPage()
            login.visit()
                .login('a', '')
                .assertNameError('Minimum length 3')
                .assertPasswordError('Required')
        })
    })

    describe('Login form with too-short name and password', function() {
        it('shows the right errors', function() {
            const login = new LoginPage();
            login.visit()
                .login('a', 'b')
                .assertNameError('Minimum length 3')
                .assertPasswordError('Minimum length 5')
        })
    })
})
