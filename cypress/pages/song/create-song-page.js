import { Admin          } from '../admin'
import { CreateSongForm } from '../../forms/create-song-form'

export class CreateSongPage extends Admin {
    pageUrl() {
        return '/song/create'
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
