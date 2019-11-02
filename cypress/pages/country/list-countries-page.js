import { Admin             } from '../admin'
import { ListCountryTable  } from '../../tables/list-country-table'
import { DeleteCountryPage } from './delete-country-page'
import { EditCountryPage   } from './edit-country-page'

export class ListCountriesPage extends Admin {

    pageUrl() {
        return '/admin/country/list'
    }

    constructor() {
        super()
        this._table = new ListCountryTable()
    }

    clickNewCountryLink() {
        this.visit()
        cy.contains('New country').click()

        return this
    }

    assertEmpty() {
        this
            .getTable()
            .assertEmpty('No country codes yet defined')

        return this
    }

    assertCountryCount(c) {
        this
            .getTable()
            .assertRowCount(c)

        return this
    }

    // Shortcut to hit the edit link in the 'n'th row
    // Returns the row object
    edit(rowIndex) {
        this.getRow(rowIndex).click('edit')
        return new EditCountryPage()
    }

    // Shortcut to hit the delete link in the 'n'th row
    // Returns the row object
    delete(rowIndex) {
        this.getRow(rowIndex).click('delete')
        return new DeleteCountryPage()
    }

}
