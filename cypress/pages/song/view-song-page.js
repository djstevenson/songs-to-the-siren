import { Public             } from '../public'
import { CreateCommentPage  } from '../comment/create-comment-page'
import { ApproveCommentPage } from '../comment/approve-comment-page'
import { RejectCommentPage  } from '../comment/reject-comment-page'
import { EditCommentPage    } from '../comment/edit-comment-page'

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
    findRootComment(n) {
        return cy.get(`section.comments > div.forest > ul.comment-root:nth-child(${n})`)
    }

    approveRootComment(n) {
        this
            .findRootComment(n)
            .find("li > div.unmoderated a:contains('Approve')")
            .click()
        
        new ApproveCommentPage()
            .approveComment()

        return this
    }

    rejectRootComment(n) {
        this
            .findRootComment(n)
            .find("li > div.unmoderated a:contains('Reject')")
            .click()
        
        new RejectCommentPage()
            .rejectComment()

        return this
    }

    editRootComment(n, args) {
        this
            .findRootComment(n)
            .find("li > div.unmoderated a:contains('Edit')")
            .click()
        
        new EditCommentPage()
            .editComment(args)

        return this
    }

    assertCommentModerated(n) {
        this
            .findRootComment(n)
            .find('li > div.unmoderated')
            .should('not.exist')

        return this
    }

    assertCommentText(n, txt) {
        this
            .findRootComment(n)
            .contains(txt)

        return this
    }

    assertCommentUnmoderated(n) {
        this
            .findRootComment(n)
            .find('li > div.unmoderated')
            .contains('COMMENT AWAITING APPROVAL')

        return this
    }

    assertEditLinkNotPresent(n) {
        this
            .findRootComment(n)
            .find('a:contains(Edit)')
            .should('not.exist')

        return this
    }

    assertEditLinkPresent(n) {
        this
            .findRootComment(n)
            .find('a:contains(Edit)')

        return this
    }

    assertEditCount(n, c) {
        const dom = this.findRootComment(n)

        if ( c == 0 ) {
            dom
                .find('div.comment-edits')
                .should('not.exist')

        }
        else {
            dom
                .find('div.comment-edits > ul > li')
                .its('length').should('eq', c)
        }
        return this
    }

    // n: selects which comment (1=first)
    // e: selects which edit (1=first)
    // args: should have 'editor' and 'reason' keys
    assertEditContent(n, e, args) {
        const dom = this.findRootComment(n)

        const sel1 = `div.comment-edits > ul > li:nth-child(${e}) > span.editor`

        this
            .findRootComment(n)
            .find(sel1)
            .contains(args.editor)

        const sel2 = `div.comment-edits > ul > li:nth-child(${e}) > span.reason`

        this
            .findRootComment(n)
            .find(sel2)
            .contains(args.reason)
        
        return this
    }

    // n: selects which comment (1=first)
    assertCommentContains(n, txt) {
        this
            .findRootComment(n)
            .contains(txt)
        
        return this
    }

    // The 'approve'/'reject' links that an admin will see
    // for an unmoderated comment.
    assertCommentModLinksPresent(n) {
        this
            .findRootComment(n)
            .find('li > div.unmoderated a:contains(Approve)')

        this
            .findRootComment(n)
            .find('li > div.unmoderated a:contains(Reject)')

        return this
    }

}
