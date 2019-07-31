/// <reference types="Cypress" />

import { SongListPage   } from '../pages/song/song-list-page'
import { SongCreatePage } from '../pages/song/song-create-page'
import { LoginPage      } from '../pages/user/login-page'
import { HomePage       } from '../pages/home-page'
import { UserFactory    } from '../support/user-factory'

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
                .assertLoggedOut()
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can not access song-list admin page', function() {
            new SongListPage()
                .assertVisitError(403)
        })
        it('can not access song-create admin page', function() {
            new SongCreatePage()
                .assertVisitError(403)
        })
    })

    describe('Access for logged-in normal user', function() {
        it('can access login page', function() {
            newUser.getNextConfirmedUser().login()
            new LoginPage()
                .visit()
                .assertLoggedOut()    // Login page logs you out
                .assertTitle('Login')

        })
        it('can access home page', function() {
            const user = newUser.getNextConfirmedUser().login()
            new HomePage()
                .visit()
                .assertLoggedInAs(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can not access song-list admin page', function() {
            const user = newUser.getNextConfirmedUser().login()
            new SongListPage()
                .assertVisitError(403)
        })
        it('can not access song-create admin page', function() {
            const user = newUser.getNextConfirmedUser().login()
            new SongCreatePage()
                .assertVisitError(403)
        })
    })

    describe('Access for logged-in admin user', function() {
        it('can access login page', function() {
            newUser.getNextConfirmedUser(true).login()
            new LoginPage()
                .visit()
                .assertLoggedOut()    // Login page logs you out
                .assertTitle('Login')

        })
        it('can access home page', function() {
            const user = newUser.getNextConfirmedUser(true).login()
            new HomePage()
                .visit()
                .assertLoggedInAs(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can access song-list admin page', function() {
            const user = newUser.getNextConfirmedUser(true).login()
            new SongListPage()
                .visit()
                .assertLoggedInAs(user.getName())
                .assertTitle('Song list')
        })
        it('can not access song-create admin page', function() {
            const user = newUser.getNextConfirmedUser(true).login()
            new SongCreatePage()
                .visit()
                .assertLoggedInAs(user.getName())
                .assertTitle('New song')
        })
    })
})
