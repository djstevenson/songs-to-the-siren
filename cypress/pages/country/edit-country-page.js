import { EditCountryForm } from '../../forms/edit-country-form'
import { BaseCountry       } from './base-country'

export class EditCountryPage extends BaseCountry {
    pageUrl() {
        // TODO Needs song name
        return '/admin/country/name/edit'
    }

    constructor() {
        super()
        this._form = new EditCountryForm()
    }

    editCountry(args) {
        this.getForm().enter(args)
    
        return this
    }
}
