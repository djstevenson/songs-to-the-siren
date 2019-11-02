import { Admin             } from '../admin'
import { CreateCountryForm } from '../../forms/create-country-form'
import { ListCountryPage   } from './list-country-page'

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

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListCountryPage()
    }
}
