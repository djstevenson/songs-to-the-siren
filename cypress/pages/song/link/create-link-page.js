import { Admin              } from '../../admin'
import { CreateSongLinkForm } from '../../../forms/create-link-form'

export class CreateSongLinkPage extends Admin {
    pageUrl() {
        // TODO Needs song id
        return '/song/n/link/create'
    }

    constructor() {
        super()
        this._form = new CreateSongLinkForm()
    }

    createLink(args) {
        this.getForm().enter(args)

        return this
    }

}
