import { EditLinkForm } from '../../forms/edit-link-form'
import { BaseLink     } from './base-link'


export class CreateLinkPage extends BaseLink {
    pageUrl() {
        // TODO Needs song id
        return '/song/n/link/create'
    }

    constructor() {
        super()
        this._form = new EditLinkForm()
    }

    createLink(args) {
        this.getForm().enter(args)

        return this
    }

}
