export class FormBase {
    constructor() {
        this._fields = new Map()
        this._buttons = new Map()
    }

    getField(name) {
        return cy.get('#' + this._fields.get(name).getSelector());
    }

    getError(name) {
        return cy.get('#error-' + this._fields.get(name).getSelector());
    }

    getButton(name) {
        return cy.get('#' + this._buttons.get(name).getSelector());
    }

    setField(name, value) {
        const field = this.getField(name)
        field.clear();
        if (value) {
            field.type(value)
        }
        return this
    }

    enter(map) {
        for (let entry of map.entries()) {
            this.setField(entry[0], entry[1])
        }

        this.getButton('submit').click()
    }

}
