import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class CreateLinkForm extends FormBase {
    constructor() {
        super();
        this._fields.identifier  = new FormField('text', 'add-link-identifier')
        this._fields.class       = new FormField('text', 'add-link-class')
        this._fields.url         = new FormField('text', 'add-link-url')
        this._fields.priority    = new FormField('text', 'add-link-priority')
        this._fields.description = new FormField('text', 'add-link-description')
        this._fields.extras      = new FormField('text', 'add-link-extras')

        this._buttons.submit     = new FormButton('create-link-button')
        this._buttons.cancel     = new FormButton('cancel-button')
    }
}
