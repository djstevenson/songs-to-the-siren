import { Admin           } from '../admin'
import { EditContentForm } from '../../forms/edit-content-form'

export class EditContentPage extends Admin {
    pageUrl() {
        // TODO Needs song name
        return '/content/name/edit'
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
