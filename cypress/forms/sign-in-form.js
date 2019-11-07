import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class SignInForm extends FormBase {
    constructor() {
        super();
        this._fields.name      = new FormField('text',     'user-sign-in-name')
        this._fields.password  = new FormField('password', 'user-sign-in-password')

        this._buttons.submit   = new FormButton('sign-in-button')
    }
}
