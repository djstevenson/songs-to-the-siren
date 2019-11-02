import { Admin             } from '../admin'
import { ListCountriesPage } from './list-countries-page'

// Base class for country-editing admin-only pages
export class BaseCountry extends Admin {

    // All the 'crud' pages have a cancel button
    // that returns to the list page.
    cancel() {
        this.getForm().getButton('cancel').click()
    
        return new ListCountriesPage()
    }
}
