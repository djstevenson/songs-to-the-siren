/// <reference types="Cypress" />

import { UserFactory       } from '../../support/user-factory'
import { ContentFactory    } from '../../support/content-factory'
import { CreateContentPage } from '../../pages/content/create-content-page'

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

context('Create Page tests', () => {
    describe('Form validation', () => {
        it('Create page page has right title', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new CreateContentPage()
                .visit()
                .assertTitle('New page')
        })

        it('Form shows right errors with empty input', () => {

            userFactory.getNextLoggedInUser(true)

            new CreateContentPage()
                .visit()
                .createContent({})
                .assertFormError('name',     'Required')
                .assertFormError('title',    'Required')
                .assertFormError('markdown', 'Required')
        })
    })

})
