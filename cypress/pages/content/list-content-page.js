import { Admin            } from '../../pages/admin'
import { ListContentTable } from '../../tables/list-content-table'

export class ListContentPage extends Admin {

    pageUrl() {
        return '/content/list'
    }

    constructor() {
        super()
        this._table = new ListContentTable()
    }

    clickNewContentLink() {
        this.visit()
        cy.contains('New content').click()

        return this
    }

    assertEmpty() {
        this
            .getTable()
            .assertEmpty('No content yet defined')

        return this
    }

    assertContentCount(c) {
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
    delete(rowIndex) {
        return this.getRow(rowIndex).click('delete')
    }
}
