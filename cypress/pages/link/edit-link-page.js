import { Admin        } from '../admin'
import { EditLinkForm } from '../../forms/edit-link-form'

export class EditLinkPage extends Admin {
    pageUrl() {
        // TODO Needs song id, link id
        return '/song/n/link/m/edit'
    }

    constructor() {
        super()
        this._form = new EditLinkForm()
    }

    editLink(args) {
        this.getForm().enter(args)

        return this
    }

}
