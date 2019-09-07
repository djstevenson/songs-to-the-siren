import { FormBase   } from '../../forms/form-base'
import { FormField  } from '../../forms/form-field'
import { FormButton } from '../../forms/form-button'

export class EditTagsForm extends FormBase {
    constructor() {
        super();
        this._fields.name    = new FormField('text', 'add-tag-name')

        this._buttons.submit = new FormButton('create-tag-button')
    }
}
