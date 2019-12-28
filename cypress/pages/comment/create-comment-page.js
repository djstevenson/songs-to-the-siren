import { CreateCommentForm } from '../../forms/create-comment-form'
import { Public            } from '../public'

export class CreateCommentPage extends Public {
    pageUrl() {
        // Need to get a song id from somewhere...
        return '/song/n/comment/create'
    }

    constructor() {
        super()
        this._form = new CreateCommentForm()
    }

    createComment(txt) {
        this.getForm().enter({
            "markdown" : txt
        })
    
        // You probably want to load a view-song-page next
        return this
    }
}
