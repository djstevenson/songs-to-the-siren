import { DeleteSongForm } from '../../forms/delete-song-form'
import { BaseSong       } from './base-song'

export class DeleteSongPage extends BaseSong {
    constructor(songId) {
        super()
        this._form = new DeleteSongForm()
        this._songId = songId
    }

    getSongId() {
        return this._songId
    }

    deleteSong() {
        this.getForm().enter({})
    
        return this
    }
}
