/// <reference types="Cypress" />

import { HomePage       } from '../pages/home-page'
import { UserFactory    } from '../support/user-factory'
import { CreateSongPage } from '../pages/song/create-song-page'

var label = 'createsong'
var userFactory = new UserFactory(label)

describe('Create Song tests', function() {
    describe('Form validation', function() {
        it('Create song page has right title', function() {

            userFactory
                .getNextConfirmedUser(true)
                .login()

            new CreateSongPage()
                .visit()
                .assertTitle('New song')
        })

        it('Form shows right errors with empty input', function() {

            // Not practical to check every validation option, but
            // do the basics
            userFactory
                .getNextConfirmedUser(true)
                .login()

            new CreateSongPage()
                .visit()
                .createSong({})
                .assertFormError('title',           'Required')
                .assertFormError('artist',          'Required')
                .assertFormError('album',           'Required')
                .assertFormError('countryId',       'Required')
                .assertFormError('releasedAt',      'Required')
                .assertFormError('summaryMarkdown', 'Required')
                .assertFormError('fullMarkdown',    'Required')
        })

        it('Form shows right errors with invalid input', function() {

            // There's deliberately minimal validation, no reason
            // why I shouldn't be able to enter a single-character
            // title for example.
            userFactory
                .getNextConfirmedUser(true)
                .login()

            new CreateSongPage()
                .visit()
                .createSong({
                    title:           'a',
                    artist:          'a',
                    album:           'a',
                    countryId:       'a',
                    releasedAt:      'a',
                    summaryMarkdown: 'a',
                    fullMarkdown:    'a'
                })
                .assertNoFormError('title')
                .assertNoFormError('artist')
                .assertNoFormError('album')
                .assertFormError('countryId', 'Invalid number')
                .assertNoFormError('releasedAt')
                .assertNoFormError('summaryMarkdown')
                .assertNoFormError('fullMarkdown')

            new CreateSongPage()
                .visit()
                .createSong({
                    title:           'a',
                    artist:          'a',
                    album:           'a',
                    countryId:       '0',
                    releasedAt:      'a',
                    summaryMarkdown: 'a',
                    fullMarkdown:    'a'
                })
                .assertNoFormError('title')
                .assertNoFormError('artist')
                .assertNoFormError('album')
                .assertFormError('countryId', 'Country id 0 does not exist')
                .assertNoFormError('releasedAt')
                .assertNoFormError('summaryMarkdown')
                .assertNoFormError('fullMarkdown')
        })
    })

})