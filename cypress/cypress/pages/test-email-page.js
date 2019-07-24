import { Common } from '../pages/common'

export class TestEmailPage extends Common {
    visit(type, username) {
        // TODO global config for base test URL
        cy.visit(`http://localhost:3000/test/view_email/${type}/${username}`)
        return this;
    }


}
