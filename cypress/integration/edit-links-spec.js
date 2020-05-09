/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { ListLinksPage  } from '../pages/link/list-links-page'
import { CreateLinkPage } from '../pages/link/create-link-page'
import { ViewSongPage   } from '../pages/song/view-song-page'

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

function makeEmbedLinkData(n) {
    const ns = n.toString()

    return {
        list_priority: '0',
        embed_class: 'Default',
        embed_identifier: 'identifier ' + ns,
        embed_url: 'http://example.com/embed_link' + ns + '.html',
        embed_description: 'embed desc of 12" version' + ns,
    }
}

function makeListLinkData(n) {
    const ns = n.toString()

    return {
        embed_identifier: '',
        list_priority: n,
        list_css: 'youtube',
        list_url: 'http://example.com/list_link' + ns + '.html',
        list_description: 'list desc of 12" version' + ns,
    }
}

function makeBothLinkData(n) {
    const ns = n.toString()

    return {
        embed_class: 'Default',
        embed_identifier: 'identifier ' + ns,
        embed_url: 'http://example.com/embed_link' + ns + '.html',
        embed_description: 'embed desc of 12" version' + ns,
        list_priority: n,
        list_css: 'youtube',
        list_url: 'http://example.com/list_link' + ns + '.html',
        list_description: 'list desc of 12" version' + ns,
    }
}

context('Song links CRUD tests', () => {
    describe('New song has empty list of links', () => {
        it('List song links page has right title, and list is empty', () => {

            const song1 = createSongListLinks()
        
            // Go to the list-links page
            new ListSongsPage()
                .visit()
                .getRow(1)
                .click('links')
                   
            // Assert list is empty
            new ListLinksPage()
                .assertTitle(`Links for ${song1.getTitle()}`)
                .assertEmpty()
        })

    })

    describe('Create form validation', () => {
        it('Create form rejects empty fields', () => {
            // Since moving to a single record for both types
            // of links, most fields are now allowed to be empty
            createSongListLinks()
            
            new ListLinksPage()
                .clickNew()
                .createLink({})
                .assertFormError('list_priority', 'Invalid number')
        })

        it('Create form rejects existing identifiers', () => {
            createSongListLinks()
            
            const linkData = makeBothLinkData(10)

            new ListLinksPage()
                .createLink(linkData)
                .clickNew()
                .createLink(linkData)
                .assertFormError('embed_identifier', 'Identifier already used for this song');
        })

        it('Create form non-integer priority', () => {
            createSongListLinks()
            
            new ListLinksPage()
                .clickNew()

            new CreateLinkPage()
                .createLink({
                    embed_identifier: 'id1',
                    embed_class: 'YouTubeEmbedded',
                    embed_url:  'http://example.com/',
                    list_priority: 'arse',
                    embed_description: 'also arse'
                })
                .assertFormError  ('list_priority', 'Invalid number')
        })
    })

    describe('Create song links', () => {
        it('Can cancel an attempt to create a link', () => {
            createSongListLinks()

            new ListLinksPage()
                .clickNew()
                .cancel()
                .assertEmpty()
        })

        it('Create links, listed in priority order', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()
                .createLink(makeBothLinkData(10))
                .assertLinkCount(1)

                .createLink(makeBothLinkData(20))
                .assertLinkCount(2)

                .createLink(makeBothLinkData(5))
                .assertLinkCount(3)

            // Check ordering
            listPage.getRow(1)
                .assertPriority(5)
                .assertIdentifier('identifier 5')

            listPage.getRow(2)
                .assertPriority(10)
                .assertIdentifier('identifier 10')

            listPage.getRow(3)
                .assertPriority(20)
                .assertIdentifier('identifier 20')

        })
    })

    describe('Edit form validation', () => {


        it('Edit form does not reject existing identifier from the link we are editing', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            const linkData = makeBothLinkData(10)

            // Test form is not rejected due to existing identifier
            // when the existing identifier is our own! i.e., edit
            // a link without changing the identifier
            listPage
                .createLink(makeBothLinkData(10))
                .edit(1)
                .editLink({list_priority: ''})  // Something invalid
                .assertNoFormError('embed_identifier')
        })

        it('Edit form rejects existing identifier from other links', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            const linkData10 = makeBothLinkData(10)
            const linkData20 = makeBothLinkData(20)

            // Create two links
            listPage.createLink(linkData10)
            listPage.createLink(linkData20)

            // Edit the second and attempt to set its identifier to the first
            listPage.edit(2)
                .editLink({embed_identifier: linkData10.embed_identifier})
                .assertFormError('embed_identifier', 'Identifier already used for this song')
        })

        it('Edit form non-integer priority', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            listPage.createLink(makeEmbedLinkData(100))
            listPage
                .edit(1)
                .editLink({
                    embed_class: 'Default',
                    embed_identifier: 'identifier1',
                    embed_url:  'http://example.com/',
                    list_priority: 'arse',
                    embed_description: 'also arse'
                })
                .assertFormError('list_priority', 'Invalid number')
        })

    })
    
    describe('Edit song links', () => {
        it('Can cancel an attempt to edit a link', () => {
            createSongListLinks()

            const listPage = new ListLinksPage()

            listPage
                .createLink(makeBothLinkData(10))

            listPage
                .edit(1)
                .cancel()
                .assertLinkCount(1)
        })

        it('Can edit links', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()
    
            const data20 = makeBothLinkData(20)
            listPage.createLink(makeBothLinkData(10))
            listPage.createLink(data20)
            listPage
                .edit(1)
                .editLink({
                    embed_identifier: 'new identifier 30',
                    list_priority: 30
                })
    
            // Link '20' should now be first, and the edited
            // link '30' second
            listPage.getRow(1).assertText('embed_identifier', data20.embed_identifier)
            listPage.getRow(2).assertText('embed_identifier', 'new identifier 30')
        })

        it('List links shown in right order', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            const linkData1 = makeBothLinkData(1001)
            const linkData2 = makeBothLinkData(1002)
            const linkData3 = makeEmbedLinkData(1003)
            const linkData4 = makeListLinkData(1004)

            //Create links in arbitrary order
            listPage
                .createLink(linkData2)
                .createLink(linkData4)
                .createLink(linkData3)
                .createLink(linkData1)
                .assertLinkCount(4)

            new ListSongsPage()
                .visit()
                .getRow(1)
                .click('title')

            new ViewSongPage()
                .assertLinkListCount(3)
                .assertLinkListItem(1, linkData1)
                .assertLinkListItem(2, linkData2)
                .assertLinkListItem(3, linkData4)
        
        })
    })

    describe('Delete song links', () => {

        it('Can cancel deletes', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()
                .createLink(makeEmbedLinkData(110))
                .createLink(makeEmbedLinkData(120))

            // Can cancel delete
            listPage
                .delete(1)
                .cancel()

            listPage.assertLinkCount(2)

        })

        it('Can delete links', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()
                .createLink(makeListLinkData(101))
                .createLink(makeListLinkData(201))

            listPage
                .delete(2)
                .deleteLink()

            listPage.assertLinkCount(1)

            listPage
                .delete(1)
                .deleteLink()

            listPage.assertEmpty()
        })

    })
    
})

