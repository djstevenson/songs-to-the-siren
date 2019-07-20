/// <reference types="Cypress" />

describe('Login tests', function() {
    describe('Login page looks right', function() {
        it('has the right title', function() {
            // TODO Put this URL in a global config somewhere
            cy.visit('http://localhost:3000/user/login')

            cy.title().should('eq', 'Login')
        })
    })

    describe('Empty login form', function() {
        it('shows the right errors', function() {
            // TODO Put this URL in a global config somewhere
            cy.visit('http://localhost:3000/user/login')

            cy.get('button#login-button').click();

            cy.get('#error-user-login-name')
                .should('contain', 'Required')
            cy.get('#error-user-login-password')
                .should('contain', 'Required')
        })
    })

    describe('Login form with too-short name', function() {
        it('shows the right errors', function() {
            // TODO Put this URL in a global config somewhere
            cy.visit('http://localhost:3000/user/login')

            cy.get('input#user-login-name').type('a');
            cy.get('button#login-button').click();

            cy.get('#error-user-login-name')
                .should('contain', 'Minimum length 3')
            cy.get('#error-user-login-password')
                .should('contain', 'Required')
        })
    })

    describe('Login form with too-short name and password', function() {
        it('shows the right errors', function() {
            // TODO Put this URL in a global config somewhere
            cy.visit('http://localhost:3000/user/login')

            cy.get('input#user-login-name').type('a');
            cy.get('input#user-login-password').type('b');
            cy.get('button#login-button').click();

            cy.get('#error-user-login-name')
                .should('contain', 'Minimum length 3')
            cy.get('#error-user-login-password')
                .should('contain', 'Minimum length 5')
        })
    })
})
