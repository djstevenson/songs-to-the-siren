import { Admin           } from '../admin'
import { EditContentForm } from '../../forms/edit-content-form'
import { ListContentPage   } from './list-content-page'

export class EditContentPage extends Admin {
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

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListContentPage()
    }
}
