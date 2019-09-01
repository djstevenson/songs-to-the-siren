/// <reference types="Cypress" />

import { UserFactory    } from '../../support/user-factory'
import { PageFactory    } from '../../support/page-factory'
import { CreatePagePage } from '../../pages/page/create-page-page'

const label = 'createpage';
const userFactory = new UserFactory(label);
const pageFactory = new PageFactory(label);

// Create pages via the form rather than
// the test-mode shortcut as we're
// testing the admin UI here.
function createPage() {
    const page = pageFactory.getNext()

    new CreatePagePage()
        .visit()
        .createPage(page.asArgs())

    return page
}

context('Create Page tests', () => {
    describe('Form validation', () => {
        it('Create page page has right title', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new CreatePagePage()
                .visit()
                .assertTitle('New page')
        })

        it('Form shows right errors with empty input', () => {

            userFactory.getNextLoggedInUser(true)

            new CreatePagePage()
                .visit()
                .createPage({})
                .assertFormError('name',     'Required')
                .assertFormError('title',    'Required')
                .assertFormError('markdown', 'Required')
        })
    })

})
