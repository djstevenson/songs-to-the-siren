import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class ForgotNameForm extends FormBase {
    constructor() {
        super();
        this._fields.set('email',    new FormField('email',    'user-forgot-name-email'))

        this._buttons.set('submit',  new FormButton('send-me-my-login-name-button'))
    }
}