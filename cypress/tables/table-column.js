export class TableColumn {
    constructor(n) {
        // n = column index, counting from 1.
        this._index = n
    }

    getIndex() {
        return this._index
    }
}
