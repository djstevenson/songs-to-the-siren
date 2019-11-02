import { DeleteCountryForm } from '../../forms/delete-country-form'
import { BaseCountry       } from './base-country'

export class DeleteCountryPage extends BaseCountry {
    constructor() {
        super()
        this._form = new DeleteCountryForm()
    }

    deleteCountry() {
        this.getForm().enter({})
    
        return this
    }
}
