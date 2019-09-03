import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class CreateContentForm extends FormBase {
    constructor() {
        super();
        this._fields.name     = new FormField('text',     'new-content-name')
        this._fields.title    = new FormField('text',     'new-content-title')
        this._fields.markdown = new FormField('textarea', 'new-content-markdown')

        this._buttons.submit  = new FormButton('create-content-button')
    }
}
