/// <reference types="Cypress" />

import { ListContentPage  } from '../../pages/content/list-content-page'
import { UserFactory      } from '../../support/user-factory'
import { ContentFactory   } from '../../support/content-factory'

const label = 'listcontent';
const userFactory = new UserFactory(label);
const contentFactory = new ContentFactory(label);

context('List Content tests', () => {

    describe('Content order etc', () => {
        it('Content list starts empty', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new ListContentPage()
                .visit()
                .assertEmpty()
        })

        it('shows content in name order', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const content1 = contentFactory.getNextContent(user, 'c')
            const content2 = contentFactory.getNextContent(user, 'a')
            const content3 = contentFactory.getNextContent(user, 'b')

            let content = new ListContentPage().visit().assertContentCount(3);

            // In order of creation, newest first
            content.getRow(1).assertText('title', content2.getTitle())
            content.getRow(2).assertText('title', content3.getTitle())
            content.getRow(3).assertText('title', content1.getTitle())
        })

    })

})
