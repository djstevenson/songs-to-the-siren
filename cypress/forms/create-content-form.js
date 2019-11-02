import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class CreateContentForm extends FormBase {
    constructor() {
        super();
        this._fields.name     = new FormField('text',     'new-content-name')
        this._fields.title    = new FormField('text',     'new-content-title')
        this._fields.markdown = new FormField('textarea', 'new-content-markdown')

        this._buttons.submit  = new FormButton('create-content-button')
        this._buttons.cancel  = new FormButton('cancel-button')
    }
}
