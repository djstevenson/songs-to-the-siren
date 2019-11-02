import { Admin           } from '../admin'
import { EditCountryForm } from '../../forms/edit-country-form'
import { ListCountriesPage   } from './list-countries-page'

export class EditCountryPage extends Admin {
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

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListCountriesPage()
    }
}
