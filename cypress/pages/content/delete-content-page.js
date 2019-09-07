import { Admin             } from '../../pages/admin'
import { DeleteContentForm } from '../../forms/delete-content-form'

export class DeleteContentPage extends Admin {
    constructor() {
        super()
        this._form = new DeleteContentForm()
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
