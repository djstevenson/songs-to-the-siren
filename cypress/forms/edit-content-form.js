import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class EditContentForm extends FormBase {
    constructor() {
        super();
        this._fields.title    = new FormField('text',     'edit-content-title')
        this._fields.markdown = new FormField('textarea', 'edit-content-markdown')

        this._buttons.submit  = new FormButton('submit-button')
        this._buttons.cancel  = new FormButton('cancel-button')
    }
}
