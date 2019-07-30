/// <reference types="Cypress" />

import { LoginPage    } from '../pages/user/login-page'
import { HomePage     } from '../pages/home-page'
import { UserFactory  } from '../support/user-factory'

var newUser = new UserFactory('access')

describe('Access control depending on user authorisation', function() {
    describe('Access while logged out', function() {
        it('can access login page', function() {
            new LoginPage()
                .visit()
                .assertLoggedOut()
                .assertTitle('Login')
        })
        it('can access home page', function() {
            new HomePage()
                .visit()
                .assertTitle('Songs I Will Never Tire of')
        })
    })

    describe('Access for logged-in normal user', function() {
        it('can access login page', function() {
            // NB Visiting the home page logs you out
            newUser.getNextConfirmedUser().login()
            new LoginPage()
                .visit()
                .assertLoggedOut()
                .assertTitle('Login')

        })
        it('can access home page', function() {
            newUser.getNextConfirmedUser().login()
            new HomePage()
                .visit()
                .assertTitle('Songs I Will Never Tire of')
        })
    })
})
