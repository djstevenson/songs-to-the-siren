import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class RegisterForm extends FormBase {
    constructor() {
        super();
        this._fields.name     = new FormField('text',     'user-register-name')
        this._fields.email    = new FormField('email',    'user-register-email')
        this._fields.password = new FormField('password', 'user-register-password')

        this._buttons.submit  = new FormButton('user-sign-up-button')
    }
}
