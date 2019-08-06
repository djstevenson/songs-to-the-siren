/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { CreateSongPage } from '../pages/song/create-song-page'
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
            new ListSongsPage()
                .assertVisitError(403)
        })
        it('can not access song-create admin page', function() {
            new CreateSongPage()
                .assertVisitError(403)
        })
    })

    describe('Access for logged-in normal user', function() {
        it('can access login page', function() {
            newUser.getNextLoggedInUser()
            new LoginPage()
                .visit()
                .assertLoggedOut()    // Login page logs you out
                .assertTitle('Login')

        })
        it('can access home page', function() {
            const user = newUser.getNextLoggedInUser()
            new HomePage()
                .visit()
                .assertLoggedInAs(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can not access song-list admin page', function() {
            const user = newUser.getNextLoggedInUser()
            new ListSongsPage()
                .assertVisitError(403)
        })
        it('can not access song-create admin page', function() {
            const user = newUser.getNextLoggedInUser()
            new CreateSongPage()
                .assertVisitError(403)
        })
    })

    describe('Access for logged-in admin user', function() {
        it('can access login page', function() {
            newUser.getNextLoggedInUser(true)
            new LoginPage()
                .visit()
                .assertLoggedOut()    // Login page logs you out
                .assertTitle('Login')

        })
        it('can access home page', function() {
            const user = newUser.getNextLoggedInUser(true)
            new HomePage()
                .visit()
                .assertLoggedInAsAdmin(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can access song-list admin page', function() {
            const user = newUser.getNextLoggedInUser(true)
            new ListSongsPage()
                .visit()
                .assertLoggedInAsAdmin(user.getName())
                .assertTitle('Song list')
        })
        it('can not access song-create admin page', function() {
            const user = newUser.getNextLoggedInUser(true)
            new CreateSongPage()
                .visit()
                .assertLoggedInAsAdmin(user.getName())
                .assertTitle('New song')
        })
    })
})
