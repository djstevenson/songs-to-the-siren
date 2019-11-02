import { CreateCountryForm } from '../../forms/create-country-form'
import { BaseCountry       } from './base-country'

export class CreateCountryPage extends BaseCountry {
    pageUrl() {
        return '/admin/country/create'
    }

    constructor() {
        super()
        this._form = new CreateCountryForm()
    }

    createCountry(args) {
        this.getForm().enter(args)
    
        return this
    }
}
