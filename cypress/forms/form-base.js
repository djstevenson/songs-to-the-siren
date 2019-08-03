export class FormBase {
    constructor() {
        this._fields  = {}
        this._buttons = {}
    }

    getField(name) {
        return cy.get('#' + this._fields[name].getSelector());
    }

    getError(name) {
        return cy.get('#error-' + this._fields[name].getSelector());
    }

    getButton(name) {
        return cy.get('#' + this._buttons[name].getSelector());
    }

    setField(name, value) {
        const field = this.getField(name)
        field.clear();
        if (value) {
            field.type(value, {delay: 0})
        }
        return this
    }

    enter(values) {
        for (var key in values) {
            this.setField(key, values[key])
        }

        this.getButton('submit').click()
    }

}
