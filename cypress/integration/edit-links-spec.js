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
        class: 'class ' + ns,
        identifier: 'identifier ' + ns,
        url: 'http://example.com/link' + ns + '.html',
        description: 'desc ' + ns,
        extras: ns + 'x' + ns
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
            createSongListLinks()
            
            new ListLinksPage()
                .clickNew()
                .createLink({})
                .assertFormError('identifier',  'Required')
                .assertFormError('class',       'Required')
                .assertFormError('url',         'Required')
                .assertFormError('description', 'Required')
                .assertFormError('priority',    'Required')
                .assertNoFormError('extras')
        })

        it('Create form rejects existing identifiers', () => {
            createSongListLinks()
            
            const linkData = makeLinkData(10)

            new ListLinksPage()
                .createLink(linkData)
                .clickNew()
                .createLink(linkData)
                .assertFormError('identifier', 'Identifier already used for this song');
        })

        it('Create form non-integer priority', () => {
            createSongListLinks()
            
            new ListLinksPage()
                .clickNew()

            new CreateLinkPage()
                .createLink({
                    identifier: 'id1',
                    class: 'class1',
                    url:  'http://example.com/',
                    priority: 'arse',
                    description: 'also arse'
                })
                .assertNoFormError('identifier')
                .assertNoFormError('class')
                .assertNoFormError('url')
                .assertNoFormError('description')
                .assertFormError  ('priority', 'Invalid number')
                .assertNoFormError('extras')
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
                .createLink(makeLinkData(10))
                .assertLinkCount(1)

                .createLink(makeLinkData(20))
                .assertLinkCount(2)

                .createLink(makeLinkData(5))
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

        it('Edit form rejects empty fields', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            listPage.createLink(makeLinkData(10))
            listPage
                .edit(1)
                .editLink({
                    class: '',
                    identifier: '',
                    url: '',
                    priority: '',
                    description: ''
                })
                .assertFormError('identifier',  'Required')
                .assertFormError('class',       'Required')
                .assertFormError('url',         'Required')
                .assertFormError('priority',    'Required')
                .assertFormError('description', 'Required')
                .assertNoFormError('extras')
        })

        it('Edit form does not reject existing identifier from the link we are editing', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            const linkData = makeLinkData(10)

            // Test form is not rejected due to existing identifier
            // when the existing identifier is our own! i.e., edit
            // a link without changing the identifier
            listPage
                .createLink(makeLinkData(10))
                .edit(1)
                .editLink({class: ''})
                .assertFormError('class', 'Required')
                .assertNoFormError('identifier')
        })

        it('Edit form rejects existing identifier from other links', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            const linkData10 = makeLinkData(10)
            const linkData20 = makeLinkData(20)

            // Create two links
            listPage.createLink(linkData10)
            listPage.createLink(linkData20)

            // Edit the second and attempt to set its identifier to the first
            listPage.edit(2)
                .editLink({identifier: linkData10.identifier})
                .assertFormError('identifier', 'Identifier already used for this song')
        })

        it('Edit form non-integer priority', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()

            listPage.createLink(makeLinkData(10))
            listPage
                .edit(1)
                .editLink({
                    class: 'class1',
                    identifier: 'identifier1',
                    url:  'http://example.com/',
                    priority: 'arse',
                    description: 'also arse'
                })
                .assertNoFormError('identifier')
                .assertNoFormError('class')
                .assertNoFormError('url')
                .assertNoFormError('description')
                .assertFormError  ('priority', 'Invalid number')
                .assertNoFormError('extras')
        })

    })
    
    describe('Edit song links', () => {
        it('Can cancel an attempt to edit a link', () => {
            createSongListLinks()

            const listPage = new ListLinksPage()

            listPage
                .createLink(makeLinkData(10))

            listPage
                .edit(1)
                .cancel()
                .assertLinkCount(1)
        })

        it('Can edit links', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()
    
            const data20 = makeLinkData(20)
            listPage.createLink(makeLinkData(10))
            listPage.createLink(data20)
            listPage
                .edit(1)
                .editLink({
                    identifier: 'new identifier 30',
                    priority: 30
                })
    
            // Link '20' should now be first, and the edited
            // link '30' second
            listPage.getRow(1).assertText('identifier', data20.identifier)
            listPage.getRow(2).assertText('identifier', 'new identifier 30')
        })
    })

    describe('Delete song links', () => {

        it('Can cancel deletes', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()
                .createLink(makeLinkData(10))
                .createLink(makeLinkData(20))

            // Can cancel delete
            listPage
                .delete(1)
                .cancel()

            listPage.assertLinkCount(2)

        })

        it('Can delete links', () => {
            createSongListLinks()
            
            const listPage = new ListLinksPage()
                .createLink(makeLinkData(10))
                .createLink(makeLinkData(20))

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

