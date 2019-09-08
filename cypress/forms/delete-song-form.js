import { FormBase   } from './form-base'
import { FormButton } from './form-button'

export class DeleteSongForm extends FormBase {
    constructor() {
        super();
        this._buttons.submit = new FormButton('delete-song-button')
        this._buttons.cancel = new FormButton('cancel-button')
    }
}
