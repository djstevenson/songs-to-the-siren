/// <reference types="Cypress" />

import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { ListSongsPage  } from '../pages/song/list-songs-page'
import { CreateSongPage } from '../pages/song/create-song-page'
import { DeleteSongPage } from '../pages/song/delete-song-page'
import { EditSongPage   } from '../pages/song/edit-song-page'

const label = 'listsong';
const userFactory = new UserFactory(label);
const songFactory = new SongFactory(label);

context('Song CRUD tests', () => {

    describe('List-songs ordering etc', () => {
        it('Song list starts empty', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new ListSongsPage()
                .visit()
                .assertEmpty()
        })

        it('shows songs in creation order, regardless of publication status', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            const song3 = songFactory.getNextSong(user)

            // In order of creation, newest first
            let page = new ListSongsPage()
                .visit()
                .assertSongCount(3)
                .assertSongTitle(1, song3.getTitle())
                .assertSongTitle(2, song2.getTitle())
                .assertSongTitle(3, song1.getTitle())

            // Publish two songs and check order remains the same
            song1.publish();
            song3.publish();

            page
                .visit()
                .assertSongCount(3)
                .assertSongTitle(1, song3.getTitle())
                .assertSongTitle(2, song2.getTitle())
                .assertSongTitle(3, song1.getTitle())
        })


    })

    describe('Publish/unpublish button', () => {
        it('Can publish/unpublish songs from the song list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            songFactory.getNextSong(user)
            songFactory.getNextSong(user)

            // Both songs should be unpublished
            new ListSongsPage()
                .visit()
                .assertSongCount(2)
                .assertSongUnpublished(1)
                .assertSongUnpublished(2)

                // Publish the 2nd one and re-check
                .publishSong(2)
                .assertSongUnpublished(1)
                .assertSongPublished(2)

                // Publish the 1st one and re-check
                .publishSong(1)
                .assertSongPublished(1)
                .assertSongPublished(2)

                // Check that we can unpublish too
                .unpublishSong(2)
                .assertSongPublished(1)
                .assertSongUnpublished(2)

        })
    })

    describe('Create form validation', () => {
        it('Create song page has right title', () => {

            userFactory.getNextLoggedInUser(true)

            new CreateSongPage()
                .visit()
                .assertTitle('New song')
        })

        it('Create song form can be cancelled', () => {
            cy.resetDatabase()

            const user  = userFactory.getNextLoggedInUser(true)
            songFactory.getNextSong(user)

            new CreateSongPage()
                .visit()
                .cancel()
                .assertSongCount(1)
        })

        it('Create song form shows right errors with empty input', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new CreateSongPage()
                .visit()
                .createSong({})
                .assertFormError('title',           'Required')
                .assertFormError('artist',          'Required')
                .assertFormError('album',           'Required')
                .assertFormError('image',           'Required')
                .assertFormError('releasedAt',      'Required')
                .assertFormError('summaryMarkdown', 'Required')
                .assertFormError('fullMarkdown',    'Required')
        })

    })

    describe('Edit form validation', () => {
        it('Edit song page has right title', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)

            new ListSongsPage()
                .visit()
                .edit(1)
                .assertTitle(`Edit song: ${song1.getTitle()}`)
        })

        it('Edit song form can be cancelled', () => {
            cy.resetDatabase()

            const user  = userFactory.getNextLoggedInUser(true)
            songFactory.getNextSong(user)

            new ListSongsPage()
                .visit()
                .edit(1)
                .cancel()
                .assertSongCount(1)
        })

        it('Edit song form shows right errors with empty input', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            songFactory.getNextSong(user)

            new ListSongsPage()
                .visit()
                .edit(1)
                .editSong({
                    title:           '',
                    artist:          '',
                    album:           '',
                    image:           '',
                    countryId:       'zz',
                    releasedAt:      '',
                    summaryMarkdown: '',
                    fullMarkdown:    ''
                })
                .assertFormError('title',           'Required')
                .assertFormError('artist',          'Required')
                .assertFormError('album',           'Required')
                .assertFormError('image',           'Required')
                .assertFormError('releasedAt',      'Required')
                .assertFormError('summaryMarkdown', 'Required')
                .assertFormError('fullMarkdown',    'Required')
        })
    })

    describe('Song list - new song goes into right place in list', () => {
        it('new song title shows up in song list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)

            const newTitle = 'x' + song1.getTitle();
            const listPage = new ListSongsPage().visit()
            listPage
                .edit(1)
                .editSong({ title: newTitle })

            listPage
                .assertSongTitle(1, newTitle)
        })

        it('song edit does not affect position in song list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            const song3 = songFactory.getNextSong(user)

            const newTitle = 'x' + song2.getTitle();
            const listPage = new ListSongsPage()
                .visit()
                .assertSongCount(3)
                .assertSongTitle(1, song3.getTitle())
                .assertSongTitle(2, song2.getTitle())
                .assertSongTitle(3, song1.getTitle())

            // Edit the title of song 2
            listPage
                .edit(2)
                .editSong({ title: newTitle });

            // Row 1 = song3, row 2 = song2, row 3 = song1
            listPage
                .visit()
                .assertSongCount(3)
                .assertSongTitle(1, song3.getTitle())
                .assertSongTitle(2, newTitle)
                .assertSongTitle(3, song1.getTitle())
        })

        // TODO Refactor to make this readable! This is a mess
        it('song edit does affect not publication status', () => {
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

            // // Now publish it, edit again, and re-check status
            // row1
            //     .click('publish')
            //     .assertPublished()
            //     .click('edit')

            // const newTitle2 = 'xy' + song1.getTitle();
            // new EditSongPage()
            //     .editSong({ title: newTitle })

            // // Check still published
            // row1.assertPublished()
        })
    })

    describe('Delete songs from song-list page', () => {
        it('Can cancel an attempt to delete a song', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            new ListSongsPage()
                .visit()
                .assertSongCount(1)
                .delete(1)
                .cancel()
                .assertSongCount(1)
        })

        it('Can delete a published song', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            const page = new ListSongsPage().visit().assertSongCount(1);

            page.getRow(1).click('publish').click('delete')

            new DeleteSongPage().deleteSong()

            page.assertEmpty()
        })

        it('Can delete an unpublished song', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            const page = new ListSongsPage().visit().assertSongCount(2);

            // song 2 now in row 1
            page.getRow(1).assertText('title', song2.getTitle())

            page.delete(1)

            new DeleteSongPage().deleteSong()

            page.assertSongCount(1)

            // song 1 now in row 1
            page.getRow(1).assertText('title', song1.getTitle())
        })

    })

})
