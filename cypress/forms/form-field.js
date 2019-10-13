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

    get() {
        const sel = this.getSelector()
        return cy.get(`#${sel}`);
    }
}
