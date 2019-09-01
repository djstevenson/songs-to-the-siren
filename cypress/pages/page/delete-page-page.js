import { Admin          } from '../../pages/admin'
import { DeletePageForm } from '../../forms/delete-page-form'

export class DeletePagePage extends Admin {
    constructor(name) {
        super()
        this._form = new DeletePageForm()
        this._name = name
    }

    getName() {
        return this._name
    }

    deletePage() {
        this.getForm().enter({})
    
        return this
    }

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return this
    }
}
