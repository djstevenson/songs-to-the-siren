/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { DeleteSongPage } from '../pages/song/delete-song-page'

var label = 'listsong'
var userFactory = new UserFactory(label)
var songFactory = new SongFactory(label)

describe('List Song tests', function() {

    describe('Song order etc', function() {
        it('Song list starts empty', function() {
            songFactory.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new ListSongsPage()
                .visit()
                .assertEmpty()
        })

        it('shows songs in creation order, regardless of publication status', function() {
            songFactory.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            const song3 = songFactory.getNextSong(user)

            var page = new ListSongsPage().visit().assertSongCount(3)

            // In order of creation, newest first
            page.getRow(1).assertText('title', song3.getTitle())
            page.getRow(2).assertText('title', song2.getTitle())
            page.getRow(3).assertText('title', song1.getTitle())

            // Publish two songs and check order remains the same
            song1.publish();
            song3.publish();

            page = new ListSongsPage().visit().assertSongCount(3)

            page.getRow(1).assertText('title', song3.getTitle()).assertPublished()
            page.getRow(2).assertText('title', song2.getTitle()).assertNotPublished()
            page.getRow(3).assertText('title', song1.getTitle()).assertPublished()
        })

    })

    describe('Publish/unpublish button', function() {
        it('Can publish/unpublish songs from the song list', function() {
            songFactory.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            var page = new ListSongsPage().visit().assertSongCount(2)

            // Both songs should be unpublished, so have 'show' links
            const row1 = page.getRow(1).assertUnpublished()
            const row2 = page.getRow(2).assertUnpublished()

            // Publish the 2nd one and re-check
            row2.click('publish')
            row1.assertUnpublished()
            row2.assertPublished()

            // Publish the 1st one and re-check
            row1.click('publish')
            row1.assertPublished()
            row2.assertPublished()

            // Check that we can unpublish too
            row2.click('publish')
            row1.assertPublished()
            row2.assertUnpublished()

        })
    })

    describe('Delete button', function() {
        it('Can delete songs from the song list', function() {
            songFactory.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            var page = new ListSongsPage().visit().assertSongCount(2)

            page.getRow(1).click('delete')

            new DeleteSongPage().cancel()

            var page = new ListSongsPage().visit().assertSongCount(2)
        })
    })

    // TODO Click through to song-view page
    // TODO Click through to song edit
    // TODO Click through to tag edit
    // TODO Click through to link edit
})
