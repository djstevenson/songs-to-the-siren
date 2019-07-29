import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class RegisterForm extends FormBase {
    constructor() {
        super();
        this._fields.set('name',     new FormField('text',     'user-register-name'))
        this._fields.set('email',    new FormField('email',    'user-register-email'))
        this._fields.set('password', new FormField('password', 'user-register-password'))

        this._buttons.set('submit',  new FormButton('user-sign-up-button'))
    }
}
