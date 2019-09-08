/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { ListLinksPage  } from '../pages/link/list-links-page'
import { CreateLinkPage } from '../pages/link/create-link-page'

const label = 'editlinks'
const userFactory = new UserFactory(label)
const songFactory = new SongFactory(label)

function createSongListLinks() {
    cy.resetDatabase()

    const user = userFactory.getNextLoggedInUser(true)
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
        name: 'link ' + ns,
        url: 'http://example.com/link' + ns + '.html',
        extras: ns + 'x' + ns
    }
}

context('Song links CRUD tests', () => {
    describe('New song has empty list of links', () => {
        it('List song links page has right title, and list is empty', () => {

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)
        
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
        it('Form rejects empty fields', () => {
            const song1 = createSongListLinks()
            
            new ListLinksPage().clickNew()

            new CreateLinkPage()
                .createLink({})
                .assertFormError('name',     'Required')
                .assertFormError('url',      'Required')
                .assertFormError('priority', 'Required')
                .assertNoFormError('extras')
        })

        it('Form non-integer priority', () => {
            const song1 = createSongListLinks()
            
            new ListLinksPage().clickNew()

            new CreateLinkPage()
                .createLink({
                    name: "name1",
                    url:  "http://example.com/",
                    priority: "arse"
                })
                .assertNoFormError('name')
                .assertNoFormError('url')
                .assertFormError  ('priority', 'Invalid number')
                .assertNoFormError('extras')
        })
    })

    describe('Create song links', () => {
        it('Create links, listed in priority order', () => {
            const song1 = createSongListLinks()
            
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
                .assertName('link 5')

            listPage.getRow(2)
            .assertPriority(10)
            .assertName('link 10')

            listPage.getRow(3)
            .assertPriority(20)
            .assertName('link 20')

        })
    })

    describe('Delete song links', () => {

        it('Can cancel deletes', () => {
            const song1 = createSongListLinks()
            
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
            const song1 = createSongListLinks()
            
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

