/// <reference types="Cypress" />

import { HomePage } from '../pages/home-page'

describe('Home page tests - song list', function() {
    describe('Song counts', function() {
        it('list starts empty', function() {
            new HomePage()
                .visit()
                .assertSongCount(0)
        })
    })
})
