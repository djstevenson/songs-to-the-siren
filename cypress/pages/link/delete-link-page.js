import { Admin          } from '../admin'
import { DeleteLinkForm } from '../../forms/delete-link-form'

export class DeleteLinkPage extends Admin {
    constructor() {
        super()
        this._form = new DeleteLinkForm()
    }

    deleteLink() {
        this.getForm().enter({})
    
        return this
    }

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return this
    }
}
