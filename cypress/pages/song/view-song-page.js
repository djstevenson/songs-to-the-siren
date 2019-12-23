import { Public            } from '../public'
import { CreateCommentPage } from '../comment/create-comment-page'

export class ViewSongPage extends Public {

    assertSongTitle(expected) {
        this.assertTitle(expected)
        cy.get('h2.title').contains(expected)
        return this
    }

    assertDescriptionContains(expected) {
        cy.get('.description').contains(expected)
        return this
    }

    assertDescriptionLink(nth, url, desc) {
        const sel = ".description > p"
        const link = cy.get(sel).find(`a:nth-child(${nth})`)
        link.contains(desc)
        link.should('have.attr', 'href').and('include', url)

        return this
    }

    createRootComment(txt) {
        cy.get('#new-comment-thread').click()
        
        return new CreateCommentPage()
            .createComment(txt)

    }
}
