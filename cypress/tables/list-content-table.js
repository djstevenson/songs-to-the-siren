import { TableBase      } from './table-base'
import { ListContentRow } from './list-content-row'

export class ListContentTable extends TableBase {
    constructor() {
        super('table-content-list')
    }

    // rowIndex starts at 1
    getRow(rowIndex) {
        return new ListContentRow(this.getId(), rowIndex)
    }
    
}
