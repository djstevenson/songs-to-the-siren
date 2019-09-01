/// <reference types="Cypress" />

import { ListPagesPage  } from '../../pages/page/list-pages-page'
import { UserFactory    } from '../../support/user-factory'
import { PageFactory    } from '../../support/page-factory'
import { DeletePagePage } from '../../pages/page/delete-page-page'

const label = 'deletepage';
const userFactory = new UserFactory(label);
const pageFactory = new PageFactory(label);

context('Delete Page tests', () => {
    describe('Delete pages from page-list page', () => {
        it('Can cancel an attempt to delete a page', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const page1 = pageFactory.getNextPage(user)
            const page = new ListPagesPage().visit().assertPageCount(1);

            page.getRow(1).click('delete')

            new DeletePagePage().cancel()

            page.visit().assertPageCount(1)
        })

        // it('Can delete a song', () => {
        //     cy.resetDatabase()

        //     const user = userFactory.getNextLoggedInUser(true)

        //     const song1 = songFactory.getNextSong(user)
        //     const page = new ListSongsPage().visit().assertSongCount(1);

        //     page.getRow(1).click('publish').click('delete')

        //     new DeleteSongPage().deleteSong()

        //     page.assertEmpty()
        // })


    })
})
