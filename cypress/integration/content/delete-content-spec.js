/// <reference types="Cypress" />

import { ListContentPage   } from '../../pages/content/list-content-page'
import { UserFactory       } from '../../support/user-factory'
import { ContentFactory    } from '../../support/content-factory'

const label = 'deletecontent';
const userFactory    = new UserFactory(label);
const contentFactory = new ContentFactory(label);

context('Delete Content tests', () => {
    describe('Delete content from content-list page', () => {
        it('Can cancel an attempt to delete content', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            contentFactory.getNextContent(user, 'a')
            const content = new ListContentPage()

            content
                .visit()
                .assertContentCount(1)
                .delete(1)
                .cancel()

            content.assertContentCount(1)
        })

        it('Can delete content', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            contentFactory.getNextContent(user, 'a')
            const content = new ListContentPage()

            content
                .visit()
                .assertContentCount(1)
                .delete(1)
                .deleteContent()

            content.assertEmpty()
        })


    })
})
