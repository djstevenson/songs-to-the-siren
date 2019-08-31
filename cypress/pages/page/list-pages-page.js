import { Admin          } from '../../pages/admin'
import { ListPagesTable } from '../../tables/list-pages-table'

export class ListPagesPage extends Admin {

    pageUrl() {
        return '/page/list'
    }

    constructor() {
        super()
        this._table = new ListPagesTable()
    }

    clickNewPageLink() {
        this.visit()
        cy.contains('New page').click()

        return this
    }

    assertEmpty() {
        this
            .getTable()
            .assertEmpty('No pages yet defined')

        return this
    }

    assertPageCount(c) {
        this
            .getTable()
            .assertRowCount(c)

        return this
    }

    // rowIndex counts from 1
    // TODO This can be in a base class? e.g. a separate
    //      base class for pages that have tables?
    getRow(rowIndex) {
        return this.getTable().getRow(rowIndex)
    }

    // Shortcut to hit the edit link in the 'n'th row
    // Returns the row object
    edit(rowIndex) {
        return this.getRow(rowIndex).click('edit')
    }

    // Shortcut to hit the delete link in the 'n'th row
    // Returns the row object
    edit(rowIndex) {
        return this.getRow(rowIndex).click('delete')
    }
}
