import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class LoginForm extends FormBase {
    constructor() {
        super();
        this._fields.name      = new FormField('text',     'user-login-name')
        this._fields.password  = new FormField('password', 'user-login-password')

        this._buttons.submit   = new FormButton('login-button')
    }
}
