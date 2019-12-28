import { RejectCommentForm } from '../../forms/reject-comment-form'
import { Public            } from '../public'

export class RejectCommentPage extends Public {
    constructor() {
        super()
        this._form = new RejectCommentForm()
    }

    rejectComment() {
        this.getForm().enter({})
    
        return this
    }
}
