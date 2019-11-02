import { CreateSongForm } from '../../forms/create-song-form'
import { BaseSong       } from './base-song'

export class CreateSongPage extends BaseSong {
    pageUrl() {
        return '/admin/song/create'
    }

    constructor() {
        super()
        this._form = new CreateSongForm()
    }

    createSong(args) {
        this.getForm().enter(args)
    
        return this
    }
}
