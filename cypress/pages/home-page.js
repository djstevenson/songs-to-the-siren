import { Public    } from '../pages/public'

export class HomePage extends Public {
    visit() {
        cy.visit('/')
        return this
    }
}
