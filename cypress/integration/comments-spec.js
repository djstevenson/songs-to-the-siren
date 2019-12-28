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

    describe('New unmoderated comment', () => {
        it('New unmoderated comment visible (but marked) to the author', () => {

            createSong()

            userFactory.getNextSignedInUser(false)

            visitSong()
                .createRootComment('test markdown 1')
                .assertCountRootComments(1)
                // Author sees comment which is flagged as needing moderation
                .assertCommentUnmoderated(1)

        })

        it('New unmoderated comment visible (but marked) to an admin', () => {

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

        it('New unmoderated comment invisible if not logged-in', () => {

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

    describe('Approved comment visible to all', () => {
        it('New reply visible (but marked) to the author', () => {

            createSong()

            const nonAuthor = userFactory.getNextSignedInUser(false)
            const admin     = userFactory.getNextSignedInUser(true)
            const author    = userFactory.getNextSignedInUser(false)

            visitSong()
                .createRootComment('test markdown 4')
                .assertCountRootComments(1)
            
            // Admin approves comment.
            admin.signIn()
            visitSong()
                .approveRootComment(1)

            // Admin sees comment not flagged for moderation
                .assertCommentModerated(1)
                .assertCommentText(1, 'markdown 4')
            
            // Author ditto
            author.signIn()
            visitSong()
                .assertCommentModerated(1)
                .assertCommentText(1, 'markdown 4')

            // Other user ditto
            nonAuthor.signIn()
            visitSong()
                .assertCommentModerated(1)
                .assertCommentText(1, 'markdown 4')

            // Also visible when logged out
            cy.signOut()
            visitSong()
                .assertCommentModerated(1)
                .assertCommentText(1, 'markdown 4')

        })

    })
})
