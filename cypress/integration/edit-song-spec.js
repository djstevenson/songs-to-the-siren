/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { EditSongPage   } from '../pages/song/edit-song-page'

const label = 'editsong';
const userFactory = new UserFactory(label);
const songFactory = new SongFactory(label);

context('Edit Song tests', () => {
    describe('Form validation', () => {
        it('Edit song page has right title', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)

            new ListSongsPage()
                .visit()
                .getRow(1)
                .click('edit')
            
            new EditSongPage()
                .assertTitle(`Edit song: ${song1.getTitle()}`)
        })

        it('Form shows right errors with empty input', () => {

            const user = userFactory.getNextLoggedInUser(true)
            songFactory.getNextSong(user)

            new ListSongsPage().edit(1)

            new EditSongPage()
                .editSong({
                    title:           '',
                    artist:          '',
                    album:           '',
                    image:           '',
                    countryId:       '',
                    releasedAt:      '',
                    summaryMarkdown: '',
                    fullMarkdown:    ''
                })
                .assertFormError('title',           'Required')
                .assertFormError('artist',          'Required')
                .assertFormError('album',           'Required')
                .assertFormError('image',           'Required')
                .assertFormError('countryId',       'Required')
                .assertFormError('releasedAt',      'Required')
                .assertFormError('summaryMarkdown', 'Required')
                .assertFormError('fullMarkdown',    'Required')
        })

        it('Form shows right errors with invalid input', () => {

            // There's deliberately minimal validation, no reason
            // why I shouldn't be able to enter a single-character
            // title for example.
            const user = userFactory.getNextLoggedInUser(true)
            songFactory.getNextSong(user)

            new ListSongsPage().edit(1)

            const page = new EditSongPage()
                .editSong({
                    title:           'a',
                    artist:          'a',
                    album:           'a',
                    image:           'a',
                    countryId:       'a',
                    releasedAt:      'a',
                    summaryMarkdown: 'a',
                    fullMarkdown:    'a'
                })
                .assertNoFormError('title')
                .assertNoFormError('artist')
                .assertNoFormError('album')
                .assertNoFormError('image')
                .assertFormError('countryId', 'Invalid number')
                .assertNoFormError('releasedAt')
                .assertNoFormError('summaryMarkdown')
                .assertNoFormError('fullMarkdown')

            page.editSong({
                    title:           'a',
                    artist:          'a',
                    album:           'a',
                    image:           'a',
                    countryId:       '0',
                    releasedAt:      'a',
                    summaryMarkdown: 'a',
                    fullMarkdown:    'a'
                })
                .assertFormError('countryId', 'Country id 0 does not exist')
        })
    })

    describe('Song list', () => {
        it('new song title shows up in song list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)

            const listPage = new ListSongsPage().visit()

            listPage.edit(1)

            const newTitle = 'x' + song1.getTitle();
            new EditSongPage()
                .editSong({ title: newTitle })
            
            listPage.getRow(1).assertText('title', newTitle)
        })

        it('song edit does not affect position in song list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            const song3 = songFactory.getNextSong(user)

            const listPage = new ListSongsPage().visit()
            // Row 1 = song3, row 2 = song2, row 3 = song1
            listPage.getRow(1).assertText('title', song3.getTitle())
            listPage.getRow(2).assertText('title', song2.getTitle())
            listPage.getRow(3).assertText('title', song1.getTitle())

            listPage.edit(2)

            const newTitle = 'x' + song2.getTitle();
            new EditSongPage()
                .editSong({ title: newTitle })
            
            // Row 1 = song3, row 2 = song2, row 3 = song1
            listPage.getRow(1).assertText('title', song3.getTitle())
            listPage.getRow(2).assertText('title', newTitle)
            listPage.getRow(3).assertText('title', song1.getTitle())
        })


        it('song edit does affect publication status', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)

            const listPage = new ListSongsPage()

            const row1 = listPage.visit().getRow(1)
            row1
                .assertUnpublished()
                .click('edit')
            

            const newTitle = 'x' + song1.getTitle();
            new EditSongPage()
                .editSong({ title: newTitle })

            // Check still not published
            row1.assertUnpublished()

            // Now publish it, edit again, and re-check status
            row1
                .click('publish')
                .assertPublished()
                .click('edit')

            const newTitle2 = 'xy' + song1.getTitle();
            new EditSongPage()
                .editSong({ title: newTitle })

            // Check still not published
            row1.assertPublished()
        })
    })
})
