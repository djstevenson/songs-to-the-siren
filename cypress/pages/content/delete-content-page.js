import { Admin             } from '../../pages/admin'
import { DeleteContentForm } from '../../forms/delete-content-form'

export class DeleteContentPage extends Admin {
    constructor(name) {
        super()
        this._form = new DeleteContentForm()
        this._name = name
    }

    getName() {
        return this._name
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