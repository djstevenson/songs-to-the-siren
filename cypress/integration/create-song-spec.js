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
    })

})
