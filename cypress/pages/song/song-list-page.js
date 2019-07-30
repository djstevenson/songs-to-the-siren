import { Admin } from '../../pages/admin'

export class LoginPage extends Admin {
    visit() {
        cy.visit('/song/list')
        return this
    }

}
