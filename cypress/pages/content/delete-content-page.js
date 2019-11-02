import { DeleteContentForm } from '../../forms/delete-content-form'
import { Admin             } from '../admin'
import { ListContentPage   } from './list-content-page'

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
    
        return new ListContentPage()
    }

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListContentPage()
    }
}
