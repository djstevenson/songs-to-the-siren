/// <reference types="Cypress" />

import { ListContentPage  } from '../../pages/content/list-content-page'
import { UserFactory      } from '../../support/user-factory'
import { ContentFactory   } from '../../support/content-factory'

const label = 'listpage';
const userFactory = new UserFactory(label);
const contentFactory = new ContentFactory(label);

context('List Page tests', () => {

    describe('Page order etc', () => {
        it('Page list starts empty', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new ListContentPage()
                .visit()
                .assertEmpty()
        })

        it('shows pages in name order', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const page1 = contentFactory.getNextContent(user, 'c')
            const page2 = contentFactory.getNextContent(user, 'a')
            const page3 = contentFactory.getNextContent(user, 'b')

            let page = new ListContentPage().visit().assertContentCount(3);

            // In order of creation, newest first
            page.getRow(1).assertText('title', page2.getTitle())
            page.getRow(2).assertText('title', page3.getTitle())
            page.getRow(3).assertText('title', page1.getTitle())
        })

    })

})
