export class FormBase {
    constructor() {
        this._fields  = {}
        this._buttons = {}
    }

    getField(name) {
        return this._fields[name]
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
        const type = field.getType()
        if (type == 'select') {
            if (value) {
                field.get().select(value)
            }
        }
        else {
            const sel = field.get()
            sel.clear();
            if (value) {
                sel.fill(value)
            }
        }
        return this
    }

    enter(values) {
        for (const key in values) {
            this.setField(key, values[key])
        }

        this.getButton('submit').click()
    }

    getValue(name) {
        return this
            .getField('name')
            .get()
            .invoke('val')
    }

    assertValue(name, val) {
        this
            .getValue(name)
            .should('eq', val)
    }
}
