import { Admin        } from '../../pages/admin'
import { EditSongForm } from '../../forms/edit-song-form'

export class EditSongPage extends Admin {
    pageUrl() {
        // TODO Needs song id
        return '/song/n/edit'
    }

    constructor() {
        super()
        this._form = new EditSongForm()
    }

    editSong(args) {
        this.getForm().enter(args)
    
        return this
    }
}
