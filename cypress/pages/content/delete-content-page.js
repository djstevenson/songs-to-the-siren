import { DeleteContentForm } from '../../forms/delete-content-form'
import { BaseContent       } from './base-content'

export class DeleteContentPage extends BaseContent {
    constructor() {
        super()
        this._form = new DeleteContentForm()
    }

    deleteContent() {
        this.getForm().enter({})
    
        return this
    }

}
