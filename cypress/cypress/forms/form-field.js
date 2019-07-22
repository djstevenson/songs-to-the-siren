export class FormField {
    constructor(type, selector) {
        this._type     = type
        this._selector = selector
    }

    getType() {
        return this._type
    }

    getSelector() {
        return this._selector
    }
}
