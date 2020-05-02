import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class EditTagsForm extends FormBase {
    constructor() {
        super();
        this._fields.name    = new FormField('text', 'add-tag-name')

        this._buttons.submit = new FormButton('create-tag-button')
    }

}
