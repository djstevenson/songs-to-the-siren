import { FormBase   } from '../forms/form-base'
import { FormField  } from '../forms/form-field'
import { FormButton } from '../forms/form-button'

export class CreateSongForm extends FormBase {
    constructor() {
        super();
        this._fields.set('title',           new FormField('text',     'new-song-title'))
        this._fields.set('artist',          new FormField('text',     'new-song-artist'))
        this._fields.set('album',           new FormField('text',     'new-song-album'))
        this._fields.set('countryId',       new FormField('text',     'new-song-country-id'))
        this._fields.set('releasedAt',      new FormField('text',     'new-song-released-at'))
        this._fields.set('summaryMarkdown', new FormField('textarea', 'new-song-summary-markdown'))
        this._fields.set('fullMarkdown',    new FormField('textarea', 'new-song-full-markdown'))

        this._buttons.set('submit',  new FormButton('create-song-button'))
    }
}
