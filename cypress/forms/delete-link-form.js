import { FormBase   } from '../forms/form-base'
import { FormButton } from '../forms/form-button'

export class DeleteLinkForm extends FormBase {
    constructor() {
        super();
        this._buttons.submit = new FormButton('delete-link-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
