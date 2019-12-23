import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class CreateCommentForm extends FormBase {
    constructor() {
        super();
        this._fields.markdown = new FormField('textarea', 'new-comment-comment-markdown')

        this._buttons.submit  = new FormButton('submit-button')
        this._buttons.cancel  = new FormButton('cancel-button')
    }
}
