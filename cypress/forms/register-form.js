import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class RegisterForm extends FormBase {
    constructor() {
        super();
        this._fields.name     = new FormField('text',     'user-register-name')
        this._fields.email    = new FormField('email',    'user-register-email')
        this._fields.password = new FormField('password', 'user-register-password')

        this._buttons.submit  = new FormButton('user-sign-up-button')
    }
}
