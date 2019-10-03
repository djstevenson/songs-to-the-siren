import { Admin             } from '../admin'
import { CreateContentForm } from '../../forms/create-content-form'

export class CreateContentPage extends Admin {
    pageUrl() {
        return '/admin/content/create'
    }

    constructor() {
        super()
        this._form = new CreateContentForm()
    }

    createContent(args) {
        this.getForm().enter(args)
    
        return this
    }
}
