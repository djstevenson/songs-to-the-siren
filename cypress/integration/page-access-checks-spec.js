/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { CreateSongPage } from '../pages/song/create-song-page'
import { SignInPage     } from '../pages/user/sign-in-page'
import { HomePage       } from '../pages/home-page'
import { UserFactory    } from '../support/user-factory'

const newUser = new UserFactory('access');

context('Access control depending on user authorisation', () => {
    describe('Access while logged out', () => {
        it('can access sign in page', () => {
            new SignInPage()
                .visit()
                .assertLoggedOut()
                .assertTitle('Sign in')
        })
        it('can access home page', () => {
            new HomePage()
                .visit()
                .assertLoggedOut()
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can not access song-list admin page', () => {
            new ListSongsPage()
                .assertVisitError(403)
        })
        it('can not access song-create admin page', () => {
            new CreateSongPage()
                .assertVisitError(403)
        })
    })

    describe('Access for logged-in normal user', () => {
        it('can access sign in page', () => {
            newUser.getNextLoggedInUser()
            new SignInPage()
                .visit()
                .assertLoggedOut()    // sign in page logs you out
                .assertTitle('Sign in')

        })
        it('can access home page', () => {
            const user = newUser.getNextLoggedInUser()
            new HomePage()
                .visit()
                .assertSignedInAs(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can not access song-list admin page', () => {
            const user = newUser.getNextLoggedInUser()
            new ListSongsPage()
                .assertVisitError(403)
        })
        it('can not access song-create admin page', () => {
            const user = newUser.getNextLoggedInUser()
            new CreateSongPage()
                .assertVisitError(403)
        })
    })

    describe('Access for logged-in admin user', () => {
        it('can access sign in page', () => {
            newUser.getNextLoggedInUser(true)
            new SignInPage()
                .visit()
                .assertLoggedOut()    // sign in page logs you out
                .assertTitle('Sign in')

        })
        it('can access home page', () => {
            const user = newUser.getNextLoggedInUser(true)
            new HomePage()
                .visit()
                .assertSignedInAsAdmin(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can access song-list admin page', () => {
            const user = newUser.getNextLoggedInUser(true)
            new ListSongsPage()
                .visit()
                .assertSignedInAsAdmin(user.getName())
                .assertTitle('Song list')
        })
        it('can not access song-create admin page', () => {
            const user = newUser.getNextLoggedInUser(true)
            new CreateSongPage()
                .visit()
                .assertSignedInAsAdmin(user.getName())
                .assertTitle('New song')
        })
    })
})
