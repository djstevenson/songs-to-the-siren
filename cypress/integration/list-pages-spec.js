/// <reference types="Cypress" />

import { ListPagesPage  } from '../pages/page/list-pages-page'
import { UserFactory    } from '../support/user-factory'
import { PageFactory    } from '../support/page-factory'

const label = 'listpage';
const userFactory = new UserFactory(label);
const pageFactory = new PageFactory(label);

context('List Page tests', () => {

    describe('Page order etc', () => {
        it('Page list starts empty', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new ListPagesPage()
                .visit()
                .assertEmpty()
        })

        it('shows pages in name order', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const page1 = pageFactory.getNextPage(user, 'c')
            const page2 = pageFactory.getNextPage(user, 'a')
            const page3 = pageFactory.getNextPage(user, 'b')

            let page = new ListPagesPage().visit().assertPageCount(3);

            // In order of creation, newest first
            page.getRow(1).assertText('title', page2.getTitle())
            page.getRow(2).assertText('title', page3.getTitle())
            page.getRow(3).assertText('title', page1.getTitle())
        })

    })

})
