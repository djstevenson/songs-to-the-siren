import { Admin             } from '../admin'
import { CreateCountryForm } from '../../forms/create-country-form'

export class CreateCountryPage extends Admin {
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
