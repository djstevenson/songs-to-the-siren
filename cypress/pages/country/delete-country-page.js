import { Admin             } from '../admin'
import { DeleteCountryForm } from '../../forms/delete-country-form'
import { ListCountryPage   } from './list-country-page'

export class DeleteCountryPage extends Admin {
    constructor() {
        super()
        this._form = new DeleteCountryForm()
    }

    deleteCountry() {
        this.getForm().enter({})
    
        return this
    }

    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListCountryPage()
    }
}