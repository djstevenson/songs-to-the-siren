import { EditSongForm } from '../../forms/edit-song-form'
import { BaseSong     } from './base-song'

export class CreateSongPage extends BaseSong {
    pageUrl() {
        return '/admin/song/create'
    }

    constructor() {
        super()
        this._form = new EditSongForm()
    }

    createSong(args) {
        this.getForm().enter(args)
    
        return this
    }
}
