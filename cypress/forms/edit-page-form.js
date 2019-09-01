import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class EditPageForm extends FormBase {
    constructor() {
        super();
        this._fields.name     = new FormField('text',     'edit-page-name')
        this._fields.title    = new FormField('text',     'edit-page-title')
        this._fields.markdown = new FormField('textarea', 'edit-page-markdown')

        this._buttons.submit  = new FormButton('update-page-button')
    }
}
