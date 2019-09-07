import { Admin          } from '../../pages/admin'
import { DeleteLinkForm } from '../../forms/delete-link-form'

export class DeleteLinkPage extends Admin {
    constructor() {
        super()
        this._form = new DeleteLinkForm()
    }

    deleteContent() {
        this.getForm().enter({})
    
        return this
    }

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return this
    }
}
