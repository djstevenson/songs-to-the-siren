/// <reference types="Cypress" />

import { ListSongsPage      } from '../../../pages/song/list-songs-page'
import { UserFactory        } from '../../../support/user-factory'
import { SongFactory        } from '../../../support/song-factory'
import { ListSongLinksPage  } from '../../../pages/song/link/list-song-links-page'
import { CreateSongLinkPage } from '../../../pages/song/link/create-song-link-page'

const label = 'createlinks'
const userFactory = new UserFactory(label)
const songFactory = new SongFactory(label)

// TODO this code used in a few places, DRY it
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

context('Create song links test', () => {
    describe('Form validation', () => {
        it('Form rejects empty fields', () => {
            const song1 = createSongListLinks()
            
            new ListSongLinksPage().clickNew()

            new CreateSongLinkPage()
                .createLink({})
                .assertFormError('name',     'Required')
                .assertFormError('url',      'Required')
                .assertFormError('priority', 'Required')
                .assertNoFormError('extras')
        })

        it('Form non-integer priority', () => {
            const song1 = createSongListLinks()
            
            new ListSongLinksPage().clickNew()

            new CreateSongLinkPage()
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

})

