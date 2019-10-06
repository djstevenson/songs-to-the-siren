import { FormBase   } from './form-base'
import { FormButton } from './form-button'

export class DeleteCountryForm extends FormBase {
    constructor() {
        super();
        this._buttons.submit = new FormButton('delete-country-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
