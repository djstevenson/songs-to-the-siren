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

// TODO Also exists in edit-links-spec, move it somewhere
//      so we don't repeat code
function makeBothLinkData(n) {
    const ns = n.toString()

    return {
        embed_class: 'Default',
        embed_identifier: 'identifier ' + ns,
        embed_url: 'http://example.com/embed_link' + ns + '.html',
        embed_description: 'embed desc of 12" version' + ns,
        list_priority: n,
        list_css: 'default',
        list_url: 'http://example.com/list_link' + ns + '.html',
        list_description: 'list desc of 12" version' + ns,
    }
}

context('Copy song link tests', () => {
    describe('Copy button creates a new link', () => {
        it('Copy link creates a new link', () => {

            createSongListLinks()
            
            const listPage = new ListLinksPage()
                .createLink(makeBothLinkData(10))
                .assertLinkCount(1)
                .copyLink(1)
                .cancel()
            
            listPage
                .assertLinkCount(2)


        })

        it('Copy link creates a new link that is the same as existing link apart from identifier', () => {

            createSongListLinks()
            
            const oldLink = makeBothLinkData(20)
            const listPage = new ListLinksPage()
                .createLink(oldLink)
                .assertLinkCount(1)
                .copyLink(1)
                .cancel()
            
            listPage.getRow(2)
                .assertPriority(oldLink.list_priority)
                .assertIdentifier(oldLink.embed_identifier + '-copy')
                .assertDescription('L: ' + oldLink.list_description)
        })

        it('Copied link is immediately editable', () => {

            createSongListLinks()
            
            const oldLink = makeBothLinkData(30)
            const newIdentifier = 'my-new-test-identifier'

            const listPage = new ListLinksPage()
                .createLink(oldLink)
                .assertLinkCount(1)
            
            listPage
                .copyLink(1)
                .editLink({embed_identifier: newIdentifier})
            
            listPage.getRow(2)
                .assertPriority(oldLink.list_priority)
                .assertIdentifier(newIdentifier)
                .assertDescription('L: ' + oldLink.list_description)
        })
    })
    
})

