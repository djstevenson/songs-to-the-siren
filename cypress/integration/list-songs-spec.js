/// <reference types="Cypress" />

import { ListSongsPage  } from '../pages/song/list-songs-page'
import { UserFactory    } from '../support/user-factory'
import { SongFactory    } from '../support/song-factory'
import { CreateSongPage } from '../pages/song/create-song-page'

var label = 'listsong'
var userFactory = new UserFactory(label)
var songFactory = new SongFactory(label)

describe('List Song tests', function() {

    describe('Song list', function() {
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

})
