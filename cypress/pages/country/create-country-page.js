import { EditCountryForm } from '../../forms/edit-country-form'
import { BaseCountry     } from './base-country'

export class CreateCountryPage extends BaseCountry {
    pageUrl() {
        return '/admin/country/create'
    }

    constructor() {
        super()
        this._form = new EditCountryForm()
    }

    createCountry(args) {
        this.getForm().enter(args)
    
        return this
    }
}
