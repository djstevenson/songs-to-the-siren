import { Public } from '../public'

export class ViewSongPage extends Public {

    assertSongTitle(expected) {
        this.assertTitle(expected)
        cy.get('h2.title').contains(expected)
        return this
    }

    assertDescriptionContains(expected) {
        cy.get('.description').contains(expected)
        return this
    }
}
