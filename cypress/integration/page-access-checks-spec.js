/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { CreateSongPage } from '../pages/song/create-song-page'
import { SignInPage     } from '../pages/user/sign-in-page'
import { HomePage       } from '../pages/home-page'
import { UserFactory    } from '../support/user-factory'

const newUser = new UserFactory('access');

context('Access control depending on user authorisation', () => {
    describe('Access while signed out', () => {
        it('can access sign in page', () => {
            new SignInPage()
                .visit()
                .assertSignedOut()
                .assertTitle('Sign in')
        })
        it('can access home page', () => {
            new HomePage()
                .visit()
                .assertSignedOut()
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

    describe('Access for signed-in normal user', () => {
        it('can access sign in page', () => {
            newUser.getNextSignedInUser()
            new SignInPage()
                .visit()
                .assertSignedOut()    // sign in page logs you out
                .assertTitle('Sign in')

        })
        it('can access home page', () => {
            const user = newUser.getNextSignedInUser()
            new HomePage()
                .visit()
                .assertSignedInAs(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can not access song-list admin page', () => {
            const user = newUser.getNextSignedInUser()
            new ListSongsPage()
                .assertVisitError(403)
        })
        it('can not access song-create admin page', () => {
            const user = newUser.getNextSignedInUser()
            new CreateSongPage()
                .assertVisitError(403)
        })
    })

    describe('Access for signed-in admin user', () => {
        it('can access sign in page', () => {
            newUser.getNextSignedInUser(true)
            new SignInPage()
                .visit()
                .assertSignedOut()    // sign in page logs you out
                .assertTitle('Sign in')

        })
        it('can access home page', () => {
            const user = newUser.getNextSignedInUser(true)
            new HomePage()
                .visit()
                .assertSignedInAsAdmin(user.getName())
                .assertTitle('Songs I Will Never Tire of')
        })
        it('can access song-list admin page', () => {
            const user = newUser.getNextSignedInUser(true)
            new ListSongsPage()
                .visit()
                .assertSignedInAsAdmin(user.getName())
                .assertTitle('Song list')
        })
        it('can not access song-create admin page', () => {
            const user = newUser.getNextSignedInUser(true)
            new CreateSongPage()
                .visit()
                .assertSignedInAsAdmin(user.getName())
                .assertTitle('New song')
        })
    })
})
