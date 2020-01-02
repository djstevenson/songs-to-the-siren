import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class EditCommentForm extends FormBase {
    constructor() {
        super();
        this._fields.bbcode  = new FormField('textarea', 'edit-comment-comment-bbcode')
        this._fields.reason  = new FormField('textarea', 'edit-comment-reason')

        this._buttons.submit = new FormButton('submit-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
