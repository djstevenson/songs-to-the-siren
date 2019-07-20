/// <reference types="Cypress" />

describe('My First Test', function() {
    it('Visits the Kitchen Sink', function() {
      cy.visit('https://example.cypress.io')

      cy.contains('type').click();

      // Should be on a URL which includes '/command/actions'
      cy.url().should('include', '/commands/actions')

      // Get an input, type into it, and verify that the value has been updated
      cy.get('.action-email')
        .type('fake@example.com')
        .should('have.value', 'fake@example.com')
    })
  })
