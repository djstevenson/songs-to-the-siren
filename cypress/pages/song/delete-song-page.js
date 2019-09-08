import { Admin          } from '../admin'
import { DeleteSongForm } from '../../forms/delete-song-form'

export class DeleteSongPage extends Admin {
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

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return this
    }
}
