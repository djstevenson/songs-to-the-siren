import { CreateContentForm } from '../../forms/create-content-form'
import { BaseContent       } from './base-content'

export class CreateContentPage extends BaseContent {
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
