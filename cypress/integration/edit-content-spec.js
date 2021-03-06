/// <reference types="Cypress" />

import { UserFactory       } from '../support/user-factory'
import { ContentFactory    } from '../support/content-factory'
import { ListContentPage   } from '../pages/content/list-content-page'
import { CreateContentPage } from '../pages/content/create-content-page'

const label = 'createcontent';
const userFactory = new UserFactory(label);
const contentFactory = new ContentFactory(label);

// Create pages via the form rather than
// the test-mode shortcut as we're
// testing the admin UI here.
function createContent() {
    const content = contentFactory.getNext()

    new CreateContentPage()
        .visit()
        .createContent(content.asArgs())

    return content
}

beforeEach( () => {
    cy.resetDatabase()
})

context('Content CRUD tests', () => {
    describe('Create form validation', () => {
        it('Create content page has right title', () => {
            userFactory.getNextSignedInUser(true)

            new CreateContentPage()
                .visit()
                .assertTitle('New content')
        })

        it('Can cancel an attempt to create content', () => {
            const user = userFactory.getNextSignedInUser(true)

            contentFactory.getNextContent(user, 'a')

            new CreateContentPage()
                .visit()
                .cancel()
                .assertContentCount(1)
        })

        it('Form shows right errors with empty input', () => {

            userFactory.getNextSignedInUser(true)

            new CreateContentPage()
                .visit()
                .createContent({})
                .assertFormError('title',    'Required')
                .assertFormError('markdown', 'Required')
        })
    })

    describe('Delete content from content-list page', () => {
        it('Can cancel an attempt to delete content', () => {
            const user = userFactory.getNextSignedInUser(true)

            contentFactory.getNextContent(user, 'a')
            const content = new ListContentPage()

            content
                .visit()
                .assertContentCount(1)
                .delete(1)
                .cancel()
                .assertContentCount(1)
        })

        it('Can delete content', () => {
            const user = userFactory.getNextSignedInUser(true)

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

    describe('Content list page, ordering', () => {
        it('Content list starts empty', () => {
            userFactory.getNextSignedInUser(true)

            new ListContentPage()
                .visit()
                .assertEmpty()
        })

        it('shows content in name order', () => {
            const user = userFactory.getNextSignedInUser(true)

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

    describe('Edit form validation', () => {
        it('Edit content page has right title', () => {
            const user = userFactory.getNextSignedInUser(true)
            const content1 = contentFactory.getNextContent(user, 'a')

            new ListContentPage()
                .visit()
                .edit(1)
                .assertTitle(`Edit content: ${content1.getName()}`)
        })

        it('Can cancel an attempt to edit content', () => {
            const user = userFactory.getNextSignedInUser(true)

            contentFactory.getNextContent(user, 'a')
            const content = new ListContentPage()

            content
                .visit()
                .assertContentCount(1)
                .edit(1)
                .cancel()
                .assertContentCount(1)
        })

        it('Form shows right errors with empty input', () => {

            const user = userFactory.getNextSignedInUser(true)
            contentFactory.getNextContent(user, 'a')

            new ListContentPage()
                .visit()
                .edit(1)
                .editContent({
                    title:    '',
                    markdown: ''
                })
                .assertFormError('title',    'Required')
                .assertFormError('markdown', 'Required')
        })
    })


    describe('Page list updates after edits', () => {
        it('new page shows up in page list', () => {
            const user = userFactory.getNextSignedInUser(true)
            const content1 = contentFactory.getNextContent(user, 'a')

            const listPage = new ListContentPage().visit()
            
            const newTitle = 'x' + content1.getTitle();
            listPage.edit(1).editContent({ title: newTitle })
            
            listPage.getRow(1).assertText('title', newTitle)
        })

    })

})
