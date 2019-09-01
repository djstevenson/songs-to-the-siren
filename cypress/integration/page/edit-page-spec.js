/// <reference types="Cypress" />

import { ListPagesPage  } from '../../pages/page/list-pages-page'
import { UserFactory    } from '../../support/user-factory'
import { PageFactory    } from '../../support/page-factory'
import { EditPagePage   } from '../../pages/page/edit-page-page'

const label = 'editpage';
const userFactory = new UserFactory(label);
const pageFactory = new PageFactory(label);

context('Edit Page tests', () => {
    describe('Form validation', () => {
        it('Edit page page has right title', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const page1 = pageFactory.getNextPage(user, 'a')

            new ListPagesPage().visit().edit(1)
            
            new EditPagePage()
                .assertTitle(`Edit page: ${page1.getName()}`)
        })

        it('Form shows right errors with empty input', () => {

            const user = userFactory.getNextLoggedInUser(true)
            pageFactory.getNextPage(user, 'a')

            new ListPagesPage().visit().edit(1)

            new EditPagePage()
                .editPage({
                    name:     '',
                    title:    '',
                    markdown: ''
                })
                .assertFormError('name',     'Required')
                .assertFormError('title',    'Required')
                .assertFormError('markdown', 'Required')
        })
    })


    describe('Page list', () => {
        it('new page shows up in page list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const page1 = pageFactory.getNextPage(user, 'a')

            const listPage = new ListPagesPage().visit()
            
            listPage.edit(1)

            const newTitle = 'x' + page1.getTitle();
            new EditPagePage()
                .editPage({ title: newTitle })
            
            listPage.getRow(1).assertText('title', newTitle)
        })

        it('changing name changes place in list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const page1 = pageFactory.getNextPage(user, 'c')
            const page2 = pageFactory.getNextPage(user, 'e')
            const page3 = pageFactory.getNextPage(user, 'a')

            const listPage = new ListPagesPage().visit()
            // Row 1 = page3, row 2 = page1, row 3 = page2
            listPage.getRow(1).assertText('name', page3.getName())
            listPage.getRow(2).assertText('name', page1.getName())
            listPage.getRow(3).assertText('name', page2.getName())

            listPage.edit(1)

            const newName = 'x' + page3.getName(); // Move to last
            new EditPagePage()
                .editPage({ name: newName })
            
            // Row 1 = page1, row 2 = page2, row 3 = page3
            listPage.getRow(1).assertText('name', page1.getName())
            listPage.getRow(2).assertText('name', page2.getName())
            listPage.getRow(3).assertText('name', newName)
        })

    })
})
