import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class ForgotNameForm extends FormBase {
    constructor() {
        super();
        this._fields.email   = new FormField('email',    'user-forgot-name-email')

        this._buttons.submit = new FormButton('send-me-my-user-name-button')
    }
}
