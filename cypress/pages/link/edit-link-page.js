import { EditLinkForm } from '../../forms/edit-link-form'
import { BaseLink     } from './base-link'

export class EditLinkPage extends BaseLink {
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
