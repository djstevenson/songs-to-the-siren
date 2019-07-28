import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class ResetPasswordForm extends FormBase {
    constructor() {
        super();
        this._fields.set('password', new FormField('email', 'user-new-password-password'))

        this._buttons.set('submit',  new FormButton('set-new-password-button'))
    }
}
