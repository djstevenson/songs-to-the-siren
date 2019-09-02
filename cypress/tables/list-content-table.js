import { TableBase      } from '../tables/table-base'
import { ListContentRow } from '../tables/list-content-row'

export class ListContentTable extends TableBase {
    constructor() {
        super('table-content-list')
    }

    // rowIndex starts at 1
    getRow(rowIndex) {
        return new ListContentRow(this.getId(), rowIndex)
    }
    
}
