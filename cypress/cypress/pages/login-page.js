import { Common } from '../pages/common'

export class LoginPage extends Common {
    getNameField() {
        return cy.get('#user-login-name')
    }

    getNameError() {
        return cy.get('#error-user-login-name')
    }

    getPasswordField() {
        return cy.get('#user-login-password')
    }

    getPasswordError() {
        return cy.get('#error-user-login-password')
    }

    getSubmitButton() {
        return cy.get('button#login-button')
    }

    submit() {
        this.getSubmitButton().click()
    }

    visit() {
        // TODO global config for base test URL
        cy.visit('http://localhost:3000/user/login')
        return this;
    }

    login(name, password) {
        const nameField = cy.get('input#user-login-name')
        nameField.clear()
        if (name) {
            nameField.type(name)
        }
        const passwordField = cy.get('input#user-login-password')
        passwordField.clear()
        if (password) {
            passwordField.type(password)
        }

        this.submit()

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
