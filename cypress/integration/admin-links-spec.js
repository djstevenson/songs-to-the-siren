/// <reference types="Cypress" />

import { HomePage     } from '../pages/home-page'
import { UserFactory  } from '../support/user-factory'

const label = 'adminlinks';
const userFactory = new UserFactory(label);

context('Admin user links to song-list', () => {
    describe('Admin user has song-list link', () => {
        it('link exists', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            // Should go to home page which has admin link
            // Click on it to go to song list which also has same link
            new HomePage()
                .visit()
                .assertSignedInAsAdmin('admin')
                .clickAdminHomeLink()
                .assertSignedInAsAdmin('admin')
        })
    })

})
