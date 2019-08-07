/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { DeleteSongPage } from '../pages/song/delete-song-page'

var label = 'deletesong'
var userFactory = new UserFactory(label)
var songFactory = new SongFactory(label)

describe('Delete Song tests', function() {
    describe('Delete songs from song-list page', function() {
        it('Can cancel an attempt to delete a song', function() {
            songFactory.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            var page = new ListSongsPage().visit().assertSongCount(1)

            page.getRow(1).click('delete')

            new DeleteSongPage().cancel()

            page.visit().assertSongCount(1)
        })

        it('Can delete a published song', function() {
            songFactory.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            var page = new ListSongsPage().visit().assertSongCount(1)

            page.getRow(1).click('publish').click('delete')

            new DeleteSongPage().deleteSong()

            page.assertEmpty()
        })

        it('Can delete an unpublished song', function() {
            songFactory.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const song1 = songFactory.getNextSong(user)
            const song2 = songFactory.getNextSong(user)
            var page = new ListSongsPage().visit().assertSongCount(2)

            // song 2 now in row 1
            page.getRow(1).assertText('title', song2.getTitle())

            page.getRow(1).click('delete')

            new DeleteSongPage().deleteSong()

            page.assertSongCount(1)

            // song 1 now in row 1
            page.getRow(1).assertText('title', song1.getTitle())
        })

    })
})
