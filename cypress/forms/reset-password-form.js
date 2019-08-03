import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class ResetPasswordForm extends FormBase {
    constructor() {
        super();
        this._fields.password = new FormField('email', 'user-new-password-password')

        this._buttons.submit  = new FormButton('set-new-password-button')
    }
}
