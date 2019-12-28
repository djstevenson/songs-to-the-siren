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

    it('New unmoderated comment visible (but marked) to the author', () => {

        createSong()

        const nonAuthor = userFactory.getNextSignedInUser(false)
        const admin     = userFactory.getNextSignedInUser(true)
        const author    = userFactory.getNextSignedInUser(false)

        visitSong()
            .createRootComment('test markdown 1')
            .assertCountRootComments(1)
            // Author sees comment which is flagged as needing moderation
            .assertCommentUnmoderated(1)

        // Admin sees comment flagged for moderation
        // and also sees the approve/reject links
        admin.signIn()
        visitSong()
            .assertCountRootComments(1)
            .assertCommentUnmoderated(1)
            .assertCommentText(1, 'markdown 1')
    
        // Other logged-in, non-admin, user does not see the comment at all
        nonAuthor.signIn()
        visitSong()
            .assertCountRootComments(0)
    
        // Logged-out user does not see the comment at all
        cy.signOut()
        visitSong()
            .assertCountRootComments(0)

    })

    it('Approved comment visibility', () => {

        createSong()

        const nonAuthor = userFactory.getNextSignedInUser(false)
        const admin     = userFactory.getNextSignedInUser(true)
        const author    = userFactory.getNextSignedInUser(false)

        visitSong()
            .createRootComment('test markdown 2')
            .assertCountRootComments(1)
        
        // Admin approves comment.
        admin.signIn()
        visitSong()
            .approveRootComment(1)

        // Admin sees comment not flagged for moderation
            .assertCountRootComments(1)
            .assertCommentModerated(1)
            .assertCommentText(1, 'markdown 2')
        
        // Author ditto
        author.signIn()
        visitSong()
            .assertCountRootComments(1)
            .assertCommentModerated(1)
            .assertCommentText(1, 'markdown 2')

        // Other user ditto
        nonAuthor.signIn()
        visitSong()
            .assertCountRootComments(1)
            .assertCommentModerated(1)
            .assertCommentText(1, 'markdown 2')

        // Also visible when logged out
        cy.signOut()
        visitSong()
            .assertCountRootComments(1)
            .assertCommentModerated(1)
            .assertCommentText(1, 'markdown 2')

    })

    it('Rejected comment visibility', () => {

        // No-one should be able to see a rejected comment.
        // TODO Consider changing this so that the author
        // still sees it, with a flag to see it's rejected ,
        // and possibly even a moderator comment to say why

        createSong()

        const nonAuthor = userFactory.getNextSignedInUser(false)
        const admin     = userFactory.getNextSignedInUser(true)
        const author    = userFactory.getNextSignedInUser(false)

        visitSong()
            .createRootComment('test markdown 3')
            .assertCountRootComments(1)
        
        // Admin rejects comment.
        admin.signIn()
        visitSong()
            .rejectRootComment(1)

        // Admin does not see comment
          .assertCountRootComments(0)
    
        // Author ditto
        author.signIn()
        visitSong()
            .assertCountRootComments(0)

        // Other user ditto
        nonAuthor.signIn()
        visitSong()
            .assertCountRootComments(0)

        // Also visible when logged out
        cy.signOut()
        visitSong()
            .assertCountRootComments(0)

    })

})
