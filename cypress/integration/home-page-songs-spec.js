/// <reference types="Cypress" />

import { HomePage     } from '../pages/home-page'
import { UserFactory  } from '../support/user-factory'
import { SongFactory  } from '../support/song-factory'

var label = 'homecounts'
var userFactory = new UserFactory(label)
var songFactory = new SongFactory(label)

describe('Home page tests - song list', () => {
    describe('Song counts', () => {
        it('list starts empty', () => {

            songFactory.resetDatabase()

            new HomePage()
                .visit()
                .assertSongCount(0)
        })
        it('shows zero songs if only unpublished songs exist', () => {

            songFactory.resetDatabase()

            const user = userFactory.getNextConfirmedUser(true)
            const song = songFactory.getNextSong(user)

            new HomePage()
                .visit()
                .assertSongCount(0)

        })
        it('with mixed published/unpublished songs, only the former are shown', () => {

            const homePage = new HomePage()

            songFactory.resetDatabase()

            const user = userFactory.getNextConfirmedUser(true)
            const song1 = songFactory.getNextSong(user, true)
            homePage
                .visit()
                .assertSongCount(1)

            const song2 = songFactory.getNextSong(user, false)
            homePage
                .visit()
                .assertSongCount(1)

            const song3 = songFactory.getNextSong(user, true)
            homePage
                .visit()
                .assertSongCount(2)
        })

        it('shows 0 songs if we publish then unpublish', () => {

            const homePage = new HomePage()

            songFactory.resetDatabase()

            const user = userFactory.getNextConfirmedUser(true)
            const song1 = songFactory.getNextSong(user, true)
            homePage
                .visit()
                .assertSongCount(1)

            const song2 = songFactory.getNextSong(user, true)
            homePage
                .visit()
                .assertSongCount(2)
    
            song1.unpublish();
            homePage
                .visit()
                .assertSongCount(1)

            song2.unpublish();
            homePage
                .visit()
                .assertSongCount(0)
        })
    })

    // By publication date, newest first
    describe('Songs shown in right order', () => {
        it('newest publication first', () => {

            const homePage = new HomePage()

            songFactory.resetDatabase()

            const user = userFactory.getNextConfirmedUser(true)

            // Create two unpublished songs
            // TODO Neater api might be:
            //  song1 = auser.createSong(false) etc
            const song1 = songFactory.getNextSong(user, false)
            const song2 = songFactory.getNextSong(user, false)
            homePage
                .visit()
                .assertSongCount(0)

            // Publish 2nd then 1st, and check the 1st is shown
            // before the 2nd
            song2.publish()
            song1.publish()
            homePage
                .visit()
                .assertSongCount(2)
            
            homePage.findSong(1).assertSongTitle(song1.getTitle())
            homePage.findSong(2).assertSongTitle(song2.getTitle())

            // Unpublish 2nd, then re-publish it. Check the 2nd
            // is shown before the 1st
            song1.unpublish()
            song2.unpublish()
            song1.publish()
            song2.publish()
            homePage
                .visit()
                .assertSongCount(2)

            homePage.findSong(1).assertSongTitle(song2.getTitle())
            homePage.findSong(2).assertSongTitle(song1.getTitle())
    
        })
    })

})
