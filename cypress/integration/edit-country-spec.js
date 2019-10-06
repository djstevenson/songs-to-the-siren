/// <reference types="Cypress" />

import { UserFactory       } from '../support/user-factory'
import { CountryFactory    } from '../support/country-factory'
import { CreateCountryPage } from '../pages/country/create-country-page'
import { ListCountryPage   } from '../pages/country/list-country-page'

const label = 'createcountry';
const userFactory = new UserFactory(label);
const countryFactory = new CountryFactory(label);

// Create pages via the form rather than
// the test-mode shortcut as we're
// testing the admin UI here.
function createCountry() {
    const country = countryFactory.getNext()

    new CreateCountryPage()
        .visit()
        .createCountry(country.asArgs())

    return country
}

context('Country CRUD tests', () => {
    describe('Create form validation', () => {
        it('Create country page has right title', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new CreateCountryPage()
                .visit()
                .assertTitle('New country')
        })

        it('Form shows right errors with empty input', () => {

            userFactory.getNextLoggedInUser(true)

            new CreateCountryPage()
                .visit()
                .createCountry({})
                .assertFormError('name',  'Required')
                .assertFormError('emoji', 'Required')
        })
    })

    describe('Delete country from country-list page', () => {
        it('Can cancel an attempt to delete country', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            countryFactory.getNextCountry(user, 'a')
            const country = new ListCountryPage()

            // Create one country, but count is two as the reset
            // code always creates one with id=1
            country
                .visit()
                .assertCountryCount(2)
                .delete(1)
                .cancel()

            country.assertCountryCount(2)
        })

        it('Can delete country', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            countryFactory.getNextCountry(user, 'a')
            const country = new ListCountryPage()

            country
                .visit()
                .assertCountryCount(2)
                .delete(1)
                .deleteCountry()
            
            country.assertCountryCount(1)

            country
                .visit()
                .assertCountryCount(1)
                .delete(1)
                .deleteCountry()

            country.assertEmpty()
        })
    })

    describe('Country list page, ordering', () => {
        it('Country list starts empty apart from test data', () => {
            cy.resetDatabase()

            userFactory.getNextLoggedInUser(true)

            new ListCountryPage()
                .visit()
                .assertCountryCount(1)
        })

        it('shows country in name order', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)

            const country1 = countryFactory.getNextCountry(user, 'c')
            const country2 = countryFactory.getNextCountry(user, 'a')
            const country3 = countryFactory.getNextCountry(user, 'b')

            let country = new ListCountryPage().visit().assertCountryCount(4);

            // In order of creation, newest first
            country.getRow(1).assertText('name', country2.getName())
            country.getRow(2).assertText('name', country3.getName())
            country.getRow(3).assertText('name', country1.getName())
        })

    })

    describe('Edit form validation', () => {
        it('Edit country page has right title', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const country1 = countryFactory.getNextCountry(user, 'a')

            new ListCountryPage()
                .visit()
                .edit(1)
                .assertTitle(`Edit country: ${country1.getName()}`)
        })

        it('Form shows right errors with empty input', () => {

            const user = userFactory.getNextLoggedInUser(true)
            countryFactory.getNextCountry(user, 'a')

            new ListCountryPage()
                .visit()
                .edit(1)
                .editCountry({
                    name:  '',
                    emoji: ''
                })
                .assertFormError('name',  'Required')
                .assertFormError('emoji', 'Required')
        })
    })


    describe('Country list updates after edits', () => {
        it('new country shows up in country list', () => {
            cy.resetDatabase()

            const user = userFactory.getNextLoggedInUser(true)
            const country1 = countryFactory.getNextCountry(user, 'a')

            const listPage = new ListCountryPage().visit()
            
            const newName = 'x' + country1.getName();
            listPage.edit(1).editCountry({ name: newName })
            
            listPage.getRow(1).assertText('name', newName)
        })

    })

})
