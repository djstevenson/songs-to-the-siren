import { Admin          } from '../admin'
import { CreateLinkForm } from '../../forms/create-link-form'

export class CreateLinkPage extends Admin {
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
