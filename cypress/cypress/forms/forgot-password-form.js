import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class ForgotPasswordForm extends FormBase {
    constructor() {
        super();
        this._fields.set('email',    new FormField('email', 'user-forgot-password-email'))

        this._buttons.set('submit',  new FormButton('request-password-reset-button'))
    }
}
