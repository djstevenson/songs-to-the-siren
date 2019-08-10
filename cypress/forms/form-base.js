export class FormBase {
    constructor() {
        this._fields  = {}
        this._buttons = {}
    }

    getField(name) {
        const sel = this._fields[name].getSelector()
        return cy.get(`#${sel}`);
    }

    getError(name) {
        const sel = this._fields[name].getSelector()
        return cy.get(`#error-${sel}`);
    }

    getButton(name) {
        const sel = this._buttons[name].getSelector()
        return cy.get(`#${sel}`);
    }

    setField(name, value) {
        const field = this.getField(name)
        field.clear();
        if (value) {
            //  field.type(value, {delay: 0})
            field.fill(value)
        }
        return this
    }

    enter(values) {
        for (const key in values) {
            this.setField(key, values[key])
        }

        this.getButton('submit').click()
    }

}
