import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class CreateCountryForm extends FormBase {
    constructor() {
        super();
        this._fields.name  = new FormField('text', 'new-country-name')
        this._fields.emoji = new FormField('text', 'new-country-emoji')

        this._buttons.submit = new FormButton('create-country-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
