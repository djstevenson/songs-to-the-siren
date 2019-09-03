import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class EditContentForm extends FormBase {
    constructor() {
        super();
        this._fields.name     = new FormField('text',     'edit-content-name')
        this._fields.title    = new FormField('text',     'edit-content-title')
        this._fields.markdown = new FormField('textarea', 'edit-content-markdown')

        this._buttons.submit  = new FormButton('update-content-button')
    }
}
