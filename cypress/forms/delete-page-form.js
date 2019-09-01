import { FormBase   } from '../forms/form-base'
import { FormButton } from '../forms/form-button'

export class DeletePageForm extends FormBase {
    constructor() {
        super();
        this._buttons.submit = new FormButton('delete-form-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
