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
        
        new CreateCommentPage()
            .createComment(txt)

        return this
    }

    assertCountRootComments(c) {
        const dom = cy.get('section.comments > div.forest')

        if ( c == 0 ) {
            dom.should('not.exist')
        }
        else {
            dom
                .find('ul.comment-root')
                .its('length').should('eq', c)
        }
        return this
    }

    // Find the 'nth' root comment
    // TODO Return some object here, and implement assertUnmoderated on that object
    findRootComment(nth) {
        return cy.get(`section.comments > div.forest > ul.comment-root:nth-child(${nth})`)
    }

    
    assertCommentUnmoderated(n) {
        this
            .findRootComment(n)
            .find('li > div.unmoderated')
            .contains('COMMENT AWAITING APPROVAL')

        return this
    }

    // The 'approve'/'reject' links that an admin will see
    // for an unmoderated commentt.
    assertCommentModLinksPresent(n) {
        this
            .findRootComment(n)
            .find("li > div.unmoderated a:contains('Approve')")

        this
            .findRootComment(n)
            .find("li > div.unmoderated a:contains('Reject')")

        return this
    }

}
