import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class EditLinkForm extends FormBase {
    constructor() {
        super();
        this._fields.identifier  = new FormField('text', 'edit-link-identifier')
        this._fields.class       = new FormField('text', 'edit-link-class')
        this._fields.url         = new FormField('text', 'edit-link-url')
        this._fields.priority    = new FormField('text', 'edit-link-priority')
        this._fields.description = new FormField('text', 'edit-link-description')
        this._fields.extras      = new FormField('text', 'edit-link-extras')

        this._buttons.submit     = new FormButton('update-link-button')
        this._buttons.cancel     = new FormButton('cancel-button')
    }
}
