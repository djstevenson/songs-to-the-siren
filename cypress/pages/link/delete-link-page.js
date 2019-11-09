import { DeleteLinkForm } from '../../forms/delete-link-form'
import { BaseLink       } from './base-link'

export class DeleteLinkPage extends BaseLink {
    constructor() {
        super()
        this._form = new DeleteLinkForm()
    }

    deleteLink() {
        this.getForm().enter({})
    
        return this
    }
}
