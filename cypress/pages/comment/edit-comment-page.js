import { EditCommentForm } from '../../forms/edit-comment-form'
import { Public          } from '../public'

export class EditCommentPage extends Public {
    constructor() {
        super()
        this._form = new EditCommentForm()
    }

    editComment(args) {
        this.getForm().enter(args)
    
        return this
    }
}
