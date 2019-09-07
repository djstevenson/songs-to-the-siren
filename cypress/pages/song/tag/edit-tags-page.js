import { Admin        } from '../../../pages/admin'
import { EditTagsForm } from '../../../forms/edit-tags-form'

export class EditTagsPage extends Admin {
    pageUrl() {
        // TODO Needs song id
        return '/song/n/tag/edit'
    }

    constructor() {
        super()
        this._form = new EditTagsForm()
    }

    createTag(args) {
        this.getForm().enter(args)
    
        return this
    }

    // Helper, gets tag-delete button selector from index, starting at 1
    _buttonSelector(nth) {
        return `ul.tag-list > li:nth-child(${nth}) > button`
    }

    // By index. TODO should this be by name?
    // Probably doesn't really matter
    // Tags numbered from 1
    deleteTag(nth) {
        const sel = this._buttonSelector(nth)
        cy
            .get(sel)
            .click()
            .wait(500)
    
        return this
    }

    assertTagCount(c) {
        const f = cy.get('ul.tag-list').find('li')
        if ( c == 0 ) {
            f.should('not.exist')
        }
        else {
            f.its('length').should('eq', c)
        }

        return this
    }

    // Counts from 1
    assertTagName(nth, name) {
        const sel = this._buttonSelector(nth) + ' > span.tag-name'
        cy
            .get(sel)
            .should('have.text', name)
        return this
    }
}
