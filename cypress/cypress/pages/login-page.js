import { Common } from '../pages/common'

export class LoginPage extends Common {
    visit() {
        // TODO global config for base test URL
        cy.visit('http://localhost:3000/user/login')
        return this;
    }

    getNameField() {
        return cy.get('#user-login-name')
    }

    setNameField(name) {
        const field = this.getNameField()
        field.clear()
        if (name) {
            field.type(name)
        }

        return this
    }
    
    getNameError() {
        return cy.get('#error-user-login-name')
    }

    getPasswordField() {
        return cy.get('#user-login-password')
    }

    setPasswordField(password) {
        const field = this.getPasswordField()
        field.clear()
        if (password) {
            field.type(password)
        }

        return this
    }
    
    getPasswordError() {
        return cy.get('#error-user-login-password')
    }

    getSubmitButton() {
        return cy.get('#login-button')
    }

    submit() {
        this.getSubmitButton().click()
        return this
    }

    login(name, password) {
        this
            .setNameField(name)
            .setPasswordField(password)
            .submit()

        return this
    }

    assertNoNameError() {
        this.getNameError().should('be.empty')
        return this
    }

    assertNameError(expected) {
        this.getNameError().contains(expected)
        return this
    }

    assertNoPasswordError() {
        this.getPasswordError().should('be.empty')
    }

    assertPasswordError(expected) {
        this.getPasswordError().contains(expected)
        return this
    }
}
