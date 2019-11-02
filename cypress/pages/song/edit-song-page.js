import { Admin         } from '../admin'
import { EditSongForm  } from '../../forms/edit-song-form'
import { ListSongsPage } from './list-songs-page'

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

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListSongsPage()
    }
}
