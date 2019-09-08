import { TableBase    } from './table-base'
import { ListLinksRow } from './list-links-row'

export class ListLinksTable extends TableBase {
    constructor() {
        super('table-song-link-list')
    }

    // rowIndex starts at 1
    getRow(rowIndex) {
        return new ListLinksRow(this.getId(), rowIndex)
    }
    
}
