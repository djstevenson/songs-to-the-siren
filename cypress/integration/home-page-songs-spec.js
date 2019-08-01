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
        it('shows zero songs after one unpublished song is added', function() {
            const user = userFactory.getNextConfirmedUser(true)
            const song = songFactory.getNextSong(user)

            new HomePage()
                .visit()
                .assertSongCount(0)

        })
        it('shows n songs after n published songs are added along with one unpublished', function() {
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
    })
})
