import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class EditCountryForm extends FormBase {
    constructor() {
        super();
        this._fields.name  = new FormField('text', 'edit-country-name')
        this._fields.emoji = new FormField('tezt', 'edit-country-emoji')

        this._buttons.submit = new FormButton('update-country-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
