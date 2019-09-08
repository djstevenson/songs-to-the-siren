import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class ForgotPasswordForm extends FormBase {
    constructor() {
        super();
        this._fields.email   = new FormField('email', 'user-forgot-password-email')

        this._buttons.submit = new FormButton('request-password-reset-button')
    }
}
