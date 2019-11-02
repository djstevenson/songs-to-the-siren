import { Admin          } from '../admin'
import { CreateSongForm } from '../../forms/create-song-form'
import { ListSongsPage  } from './list-songs-page'

export class CreateSongPage extends Admin {
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

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListSongsPage()
    }
}
