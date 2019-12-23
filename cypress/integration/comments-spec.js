/// <reference types="Cypress" />

import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { HomePage       } from '../pages/home-page'
import { ViewSongPage   } from '../pages/song/view-song-page'

const label = 'listsong';
const userFactory = new UserFactory(label);
const songFactory = new SongFactory(label);

beforeEach( () => {
    cy.resetDatabase()
})

// Creates a song, does not go to the view as we'll
// generally want to change user first.
function createSong() {

    const user = userFactory.getNextSignedInUser(true)
    return songFactory.getNextSong(user, true)
}

// Visits first song on home page, ie the most-recently 
// created one. 
function visitSong() {

    new HomePage()
        .visit()
        .findSong(1)
        .visit()

    return new ViewSongPage()
}

context('Comments are shown (or hidden) correctly', () => {

    describe('New root comment', () => {
        it('New comment invisible if not logged-in', () => {

            const song = createSong()

            cy.signOut()

            visitSong()
                .assertSongTitle(song.getTitle())

        })


    })

})
