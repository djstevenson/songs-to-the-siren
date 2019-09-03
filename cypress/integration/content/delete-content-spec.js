/// <reference types="Cypress" />

import { ListContentPage   } from '../../pages/content/list-content-page'
import { UserFactory       } from '../../support/user-factory'
import { ContentFactory    } from '../../support/content-factory'
import { DeleteContentPage } from '../../pages/content/delete-content-page'

const label = 'deletecontent';
const userFactory    = new UserFactory(label);
const contentFactory = new ContentFactory(label);

context('Delete Content tests', () => {
    describe('Delete content from content-list page', () => {
        it('Can cancel an attempt to delete content', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            contentFactory.getNextContent(user, 'a')
            const content = new ListContentPage().visit().assertContentCount(1);

            content.delete(1)

            new DeleteContentPage().cancel()

            content.visit().assertContentCount(1)
        })

        it('Can delete content', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            contentFactory.getNextContent(user, 'a')
            const content = new ListContentPage().visit().assertContentCount(1);

            content.delete(1)

            new DeleteContentPage().deleteContent()

            content.assertEmpty()
        })


    })
})
