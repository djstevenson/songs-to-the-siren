import { RowBase     } from './row-base'
import { TableColumn } from './table-column'

export class ListSongsRow extends RowBase {
    constructor(tableId, rowIndex) {
        super(tableId, rowIndex);
        this._columns.id          = new TableColumn(1)
        this._columns.title       = new TableColumn(2)
        this._columns.unapproved  = new TableColumn(3)
        this._columns.publishedAt = new TableColumn(4)
        this._columns.publish     = new TableColumn(5)
        this._columns.tags        = new TableColumn(6)
        this._columns.links       = new TableColumn(7)
        this._columns.edit        = new TableColumn(8)
        this._columns.delete      = new TableColumn(9)
    }

    // publishedAt should be a date
    // Publish link should be 'Hide'
    assertPublished() {
        this.assertRegex('publishedAt', /\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d/)
        this.assertText('publish', 'Hide')

        return this // Chainable
    }

    // publishedAt should be empty
    // Publish link should be 'Show'
    assertUnpublished() {
        this.assertNoText('publishedAt')
        this.assertText('publish', 'Show')

        return this // Chainable
    }
}
