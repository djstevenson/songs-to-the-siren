/// <reference types="Cypress" />

import { HomePage     } from '../pages/home-page'
import { UserFactory  } from '../support/user-factory'
import { SongFactory  } from '../support/song-factory'

var label = 'homecounts'
var userFactory = new UserFactory(label)
var songFactory = new SongFactory(label)

describe('Home page tests - song list', function() {
    describe('Song counts', function() {
        it('list starts empty', function() {

            songFactory.resetDatabase()

            new HomePage()
                .visit()
                .assertSongCount(0)
        })
        it('shows zero songs if only unpublished songs exist', function() {

            songFactory.resetDatabase()

            const user = userFactory.getNextConfirmedUser(true)
            const song = songFactory.getNextSong(user)

            new HomePage()
                .visit()
                .assertSongCount(0)

        })
        it('with mixed published/unpublished songs, only the former are shown', function() {

            songFactory.resetDatabase()

            const user = userFactory.getNextConfirmedUser(true)
            const song1 = songFactory.getNextSong(user, true)
            new HomePage()
                .visit()
                .assertSongCount(1)

            const song2 = songFactory.getNextSong(user, false)
            new HomePage()
                .visit()
                .assertSongCount(1)

            const song3 = songFactory.getNextSong(user, true)
            new HomePage()
                .visit()
                .assertSongCount(2)
        })

        it('shows 0 songs if we publish then unpublish', function() {

            songFactory.resetDatabase()

            const user = userFactory.getNextConfirmedUser(true)
            const song1 = songFactory.getNextSong(user, true)
            new HomePage()
                .visit()
                .assertSongCount(1)

            const song2 = songFactory.getNextSong(user, true)
            new HomePage()
                .visit()
                .assertSongCount(2)
    
            song1.unpublish();
            new HomePage()
                .visit()
                .assertSongCount(1)

            song2.unpublish();
            new HomePage()
                .visit()
                .assertSongCount(0)
        })
    })
})
