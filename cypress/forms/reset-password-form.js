import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class ResetPasswordForm extends FormBase {
    constructor() {
        super();
        this._fields.password = new FormField('email', 'user-new-password-password')

        this._buttons.submit  = new FormButton('set-new-password-button')
    }
}
