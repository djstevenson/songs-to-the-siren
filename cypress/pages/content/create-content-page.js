import { CreateContentForm } from '../../forms/create-content-form'
import { Admin             } from '../admin'
import { ListContentPage   } from './list-content-page'

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

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListContentPage()
    }
}
