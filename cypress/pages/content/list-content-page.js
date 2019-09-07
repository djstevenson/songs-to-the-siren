import { Admin             } from '../../pages/admin'
import { ListContentTable  } from '../../tables/list-content-table'
import { DeleteContentPage } from '../../pages/content/delete-content-page'
import { EditContentPage   } from '../../pages/content/edit-content-page'

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

    // Shortcut to hit the edit link in the 'n'th row
    // Returns the row object
    edit(rowIndex) {
        this.getRow(rowIndex).click('edit')
        return new EditContentPage()
    }

    // Shortcut to hit the delete link in the 'n'th row
    // Returns the row object
    delete(rowIndex) {
        this.getRow(rowIndex).click('delete')
        return new DeleteContentPage()
    }

}
