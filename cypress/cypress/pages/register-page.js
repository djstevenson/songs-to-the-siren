import { Common } from '../pages/common'

export class RegisterPage extends Common {
    visit() {
        // TODO global config for base test URL
        cy.visit('http://localhost:3000/user/register')
        return this;
    }

    getNameField() {
        return cy.get('#user-register-name')
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
        return cy.get('#error-user-register-name')
    }

    getEmailField() {
        return cy.get('#user-register-email')
    }

    setEmailField(email) {
        const field = this.getEmailField()
        field.clear()
        if (email) {
            field.type(email)
        }

        return this
    }
    
    getEmailError() {
        return cy.get('#error-user-register-email')
    }

    getPasswordField() {
        return cy.get('#user-register-password')
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
        return cy.get('#error-user-register-password')
    }

    getSubmitButton() {
        return cy.get('#user-register-button')
    }

    submit() {
        this.getSubmitButton().click()
    }

    register(name, email, password) {
        this
            .setNameField(name)
            .setEmailField(email)
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

    assertNoEmailError() {
        this.getEmailError().should('be.empty')
        return this
    }

    assertEmailError(expected) {
        this.getEmailError().contains(expected)
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
