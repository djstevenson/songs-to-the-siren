import { FormBase   } from './form-base'
import { FormField  } from './form-field'
import { FormButton } from './form-button'

export class EditLinkForm extends FormBase {
    constructor() {
        super();
        this._fields.embed_identifier  = new FormField('text',   'edit-link-embed-identifier')
        this._fields.embed_url         = new FormField('text',   'edit-link-embed-url')
        this._fields.embed_class       = new FormField('select', 'edit-link-embed-class')
        this._fields.embed_description = new FormField('text',   'edit-link-embed-description')

        this._fields.list_priority     = new FormField('text',   'edit-link-list-priority')
        this._fields.list_url          = new FormField('text',   'edit-link-list-url')
        this._fields.list_css          = new FormField('select', 'edit-link-list-css')
        this._fields.list_description  = new FormField('text',   'edit-link-list-description')

        this._buttons.submit     = new FormButton('submit-button')
        this._buttons.cancel     = new FormButton('cancel-button')
    }
}
