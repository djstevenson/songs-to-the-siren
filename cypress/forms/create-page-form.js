import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class CreatePageForm extends FormBase {
    constructor() {
        super();
        this._fields.name     = new FormField('text',     'new-page-name')
        this._fields.title    = new FormField('text',     'new-page-title')
        this._fields.markdown = new FormField('textarea', 'new-page-markdown')

        this._buttons.submit  = new FormButton('create-page-button')
    }
}
