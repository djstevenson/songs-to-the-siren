import { Admin          } from '../../pages/admin'
import { ListSongsTable } from '../../tables/list-songs-table'

export class ListSongsPage extends Admin {

    pageUrl() {
        return '/song/list'
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

    // rowIndex counts from 1
    getRow(rowIndex) {
        return this.getTable().getRow(rowIndex)
    }

    // Shortcut to hit the edit link in the 'n'th row
    edit(rowIndex) {
        return this.getRow(rowIndex).click('edit')
    }
}
