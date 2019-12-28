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

// Creates a song as a new admin user
// Logs out
// Returns the song
function createSong() {

    const user = userFactory.getNextSignedInUser(true)
    const song = songFactory.getNextSong(user, true)
    cy.signOut()

    return song    
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

    // TODO Extend tests to include replies to other comments, too.
    
    describe('New root comment', () => {
        it('New comment visible (but marked) to the author', () => {

            createSong()

            userFactory.getNextSignedInUser(false)

            visitSong()
                .createRootComment('test markdown 1')
                .assertCountRootComments(1)
                // Author sees comment which is flagged as needing moderation
                .assertCommentUnmoderated(1)

        })

        it('New comment visible (but marked) to an admin', () => {

            createSong()

            userFactory.getNextSignedInUser(true)

            visitSong()
                .createRootComment('test markdown 2')
                .assertCountRootComments(1)
                // Admin sees comment which is flagged as needing moderation
                .assertCommentUnmoderated(1)
                // Admin also sees 'approve' and 'delete' links.
                .assertCommentModLinksPresent(1)

        })

        it('New comment invisible if not logged-in', () => {

            createSong()

            userFactory.getNextSignedInUser(false)

            visitSong()
                .createRootComment('test markdown 3')
            
            // Logout and revisit song, check that I can't see
            // unmodded comment as I am not logged in
            cy.signOut()

            visitSong()
                .assertCountRootComments(0)
        })

    })

})
