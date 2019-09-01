import { Admin         } from '../../pages/admin'
import { CreatePageForm } from '../../forms/create-page-form'

export class CreatePagePage extends Admin {
    pageUrl() {
        return '/page/create'
    }

    constructor() {
        super()
        this._form = new CreatePageForm()
    }

    createPage(args) {
        this.getForm().enter(args)
    
        return this
    }
}
