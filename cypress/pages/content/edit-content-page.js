import { EditContentForm } from '../../forms/edit-content-form'
import { BaseContent       } from './base-content'

export class EditContentPage extends BaseContent {
    pageUrl() {
        // TODO Needs song name
        return '/admin/content/name/edit'
    }

    constructor() {
        super()
        this._form = new EditContentForm()
    }

    editContent(args) {
        this.getForm().enter(args)
    
        return this
    }
}
