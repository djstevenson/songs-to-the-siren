import { Admin          } from '../admin'
import { ListSongsTable } from '../../tables/list-songs-table'

export class ListSongsPage extends Admin {

    pageUrl() {
        return '/admin/song/list'
    }

    constructor() {
        super()
        this._table = new ListSongsTable()
    }

    clickNewSongLink() {
        this.visit()
        cy.contains('New song').click()

        return this
    }

    assertEmpty() {
        this
            .getTable()
            .assertEmpty('No songs yet defined')

        return this
    }

    assertSongCount(c) {
        this
            .getTable()
            .assertRowCount(c)

        return this
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
