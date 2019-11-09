import { CreateLinkForm } from '../../forms/create-link-form'
import { BaseLink       } from './base-link'


export class CreateLinkPage extends BaseLink {
    pageUrl() {
        // TODO Needs song id
        return '/song/n/link/create'
    }

    constructor() {
        super()
        this._form = new CreateLinkForm()
    }

    createLink(args) {
        this.getForm().enter(args)

        return this
    }

}
