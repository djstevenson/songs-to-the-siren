import { FormBase   } from './form-base'
import { FormButton } from './form-button'

export class ApproveCommentForm extends FormBase {
    constructor() {
        super();
        this._buttons.submit = new FormButton('approve-comment-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
