/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { ListLinksPage  } from '../pages/link/list-links-page'
import { CreateLinkPage } from '../pages/link/create-link-page'

const label = 'editlinks'
const userFactory = new UserFactory(label)
const songFactory = new SongFactory(label)

beforeEach( () => {
    cy.resetDatabase()
})

// Creates a user and song, and loads the list-links
// page for the song. Does not create any links
function createSongListLinks() {
    const user = userFactory.getNextSignedInUser(true)
    const song1 = songFactory.getNextSong(user)

    new ListSongsPage()
        .visit()
        .getRow(1)
        .click('links')

    return song1
}

function makeLinkData(n) {
    const ns = n.toString()

    return {
        priority: n,
        class: 'Default',
        identifier: 'identifier ' + ns,
        url: 'http://example.com/link' + ns + '.html',
        description: 'desc of 12" version' + ns,
        extras: ns + 'x' + ns,
        title: 'title' + ns,
        css: 'default',
    }
}

context('Copy song link tests', () => {
    describe('Copy button creates a new link', () => {
        it('Copy link creates a new link', () => {

            createSongListLinks()
            
            const listPage = new ListLinksPage()
                .createLink(makeLinkData(10))
                .assertLinkCount(1)
                .copyLink(1)
                .cancel()
            
            listPage
                .assertLinkCount(2)


        })

        it('Copy link creates a new link that is the same as existing link apart from identifier', () => {

            createSongListLinks()
            
            const oldLink = makeLinkData(20)
            const listPage = new ListLinksPage()
                .createLink(oldLink)
                .assertLinkCount(1)
                .copyLink(1)
                .cancel()
            
            listPage.getRow(2)
                .assertPriority(oldLink.priority)
                .assertIdentifier(oldLink.identifier + '-copy')
                .assertDescription(oldLink.description)


        })

        it('Copied link is immediately editable', () => {

            createSongListLinks()
            
            const oldLink = makeLinkData(30)
            const newIdentifier = 'my-new-test-identifier'

            const listPage = new ListLinksPage()
                .createLink(oldLink)
                .assertLinkCount(1)
            
            listPage
                .copyLink(1)
                .editLink({identifier: newIdentifier})
            
            listPage.getRow(2)
                .assertPriority(oldLink.priority)
                .assertIdentifier(newIdentifier)
                .assertDescription(oldLink.description)


        })
    })
    
})

