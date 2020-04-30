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

    it('Admin edits a comment', () => {

        // Currently, can only edit before approval.
        // TODO Change this to allow editing at any time.
        // TODO Add deletion too.

        createSong()

        const admin     = userFactory.getNextSignedInUser(true)
        const author    = userFactory.getNextSignedInUser(false)

        const bb1 = 'test abc bbcode 4'
        const bb2 = 'test def bbcode 4 edited'
        const bb3 = 'test xyz bbcode 4 re-edited'

        const reason1 = 'Cypress 1 test'
        const reason2 = 'Cypress 2 test'

        // "author" creates comment. Does not get edit link
        visitSong()
            .createRootComment(bb1)
            .assertCountRootComments(1)
            .assertEditLinkNotPresent(1)
            .assertCommentContains(1, bb1)
        
        // Admin does get edit link. Check that there
        // are no edits initially, then make an edit,
        // and check that there is now one, then check
        // its contents.
        // And then does another edit...
        admin.signIn()
        visitSong()
            .assertCountRootComments(1)
            .assertEditLinkPresent(1)
            .assertEditCount(1, 0)  // First comment, zero edits
            .editRootComment(1, {
                bbcode: bb2,
                reason: reason1
            })
            .assertCommentContains(1, bb2)
            .assertEditCount(1, 1)  // First comment, one edit
            .assertEditContent(1, 1, { // First comment, first edit
                editor: admin.getName(),
                reason: reason1
            })

            .editRootComment(1, {
                bbcode: bb3,
                reason: reason2
            })
            .assertCommentContains(1, bb3)
            .assertEditCount(1, 2)  // First comment, two edits
            .assertEditContent(1, 1, { // First comment, first edit (newest)
                editor: admin.getName(),
                reason: reason2
            })

            // Admin approves, and edits still show when logged out
            .approveRootComment(1)
        
        cy.signOut()
        visitSong()
            .assertCommentContains(1, bb3)
            .assertEditCount(1, 2)  // First comment, two edits
            .assertEditContent(1, 1, { // First comment, first edit (newest)
                editor: admin.getName(),
                reason: reason2
            })

    })
})

context('New comments/replies generate admin notifications', () => {
    it('New comment generates notifications', () => {


        const song = createSong()

        const admin1    = userFactory.getNextSignedInUser(true)
        const admin2    = userFactory.getNextSignedInUser(true)
        const author    = userFactory.getNextSignedInUser(false)
        const other     = userFactory.getNextSignedInUser(false)

        const bb1 = 'test abc bbcode 5'

        // "author" creates comment
        visitSong()
            .createRootComment(bb1)

        // Email notifications were generate for both admins
        // but not for author or other non-admin user

        admin1.getEmailPage('comment_notification')
            .assertData('song_title', song.getTitle())

        admin2.getEmailPage('comment_notification')
            .assertData('song_title', song.getTitle())
        
        author.assertHasNoEmail('comment_notification')
        other.assertHasNoEmail('comment_notification')

    })


})
