import { ApproveCommentForm } from '../../forms/approve-comment-form'
import { Public             } from '../public'

export class ApproveCommentPage extends Public {
    constructor() {
        super()
        this._form = new ApproveCommentForm()
    }

    approveComment() {
        this.getForm().enter({})
    
        return this
    }
}
