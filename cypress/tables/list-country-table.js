import { TableBase      } from './table-base'
import { ListCountryRow } from './list-country-row'

export class ListCountryTable extends TableBase {
    constructor() {
        super('table-country-list')
    }

    // rowIndex starts at 1
    getRow(rowIndex) {
        return new ListCountryRow(this.getId(), rowIndex)
    }
    
}
