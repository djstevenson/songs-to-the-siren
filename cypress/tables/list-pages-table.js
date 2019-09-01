import { TableBase    } from '../tables/table-base'
import { ListPagesRow } from '../tables/list-pages-row'

export class ListPagesTable extends TableBase {
    constructor() {
        super('table-page-list')
    }

    // rowIndex starts at 1
    getRow(rowIndex) {
        return new ListPagesRow(this.getId(), rowIndex)
    }
    
}
