import { EditSongForm  } from '../../forms/edit-song-form'
import { BaseSong      } from './base-song'

export class EditSongPage extends BaseSong {
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
