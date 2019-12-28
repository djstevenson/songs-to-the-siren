import { FormBase   } from './form-base'
import { FormButton } from './form-button'

export class RejectCommentForm extends FormBase {
    constructor() {
        super();
        this._buttons.submit = new FormButton('reject-comment-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
