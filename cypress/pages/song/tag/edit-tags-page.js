import { Admin        } from '../../../pages/admin'
import { EditTagsForm } from '../../../forms/song/edit-tags-form'

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

    assertTagCount(c) {
        const f = cy.get('ul.tag-list').find('li')
        if ( c == 0 ) {
            f.should('not.exist')
        }
        else {
            f.its('length').should('eq', c)
        }
    }
}
