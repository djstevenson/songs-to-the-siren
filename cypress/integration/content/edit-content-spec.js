/// <reference types="Cypress" />

import { ListContentPage } from '../../pages/content/list-content-page'
import { UserFactory     } from '../../support/user-factory'
import { ContentFactory  } from '../../support/content-factory'
import { EditContentPage } from '../../pages/content/edit-content-page'

const label = 'editcontent';
const userFactory    = new UserFactory(label);
const contentFactory = new ContentFactory(label);

context('Edit Content tests', () => {
    describe('Form validation', () => {
        it('Edit content page has right title', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const content1 = contentFactory.getNextContent(user, 'a')

            new ListContentPage().visit().edit(1)
            
            new EditContentPage()
                .assertTitle(`Edit content: ${content1.getName()}`)
        })

        it('Form shows right errors with empty input', () => {

            const user = userFactory.getNextLoggedInUser(true)
            contentFactory.getNextContent(user, 'a')

            new ListContentPage().visit().edit(1)

            new EditContentPage()
                .editContent({
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
            const content1 = contentFactory.getNextContent(user, 'a')

            const listPage = new ListContentPage().visit()
            
            listPage.edit(1)

            const newTitle = 'x' + content1.getTitle();
            new EditContentPage()
                .editContent({ title: newTitle })
            
            listPage.getRow(1).assertText('title', newTitle)
        })

        it('changing name changes place in list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const content1 = contentFactory.getNextContent(user, 'c')
            const content2 = contentFactory.getNextContent(user, 'e')
            const content3 = contentFactory.getNextContent(user, 'a')

            const listPage = new ListContentPage().visit()
            // Row 1 = content3, row 2 = content1, row 3 = content2
            listPage.getRow(1).assertText('name', content3.getName())
            listPage.getRow(2).assertText('name', content1.getName())
            listPage.getRow(3).assertText('name', content2.getName())

            listPage.edit(1)

            const newName = 'x' + content3.getName(); // Move to last
            new EditContentPage()
                .editContent({ name: newName })
            
            // Row 1 = content1, row 2 = content2, row 3 = content3
            listPage.getRow(1).assertText('name', content1.getName())
            listPage.getRow(2).assertText('name', content2.getName())
            listPage.getRow(3).assertText('name', newName)
        })

    })
})
