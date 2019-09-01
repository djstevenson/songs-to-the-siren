import { Admin        } from '../../pages/admin'
import { EditPageForm } from '../../forms/edit-page-form'

export class EditPagePage extends Admin {
    pageUrl() {
        // TODO Needs song name
        return '/page/name/edit'
    }

    constructor() {
        super()
        this._form = new EditPageForm()
    }

    editPage(args) {
        this.getForm().enter(args)
    
        return this
    }
}
