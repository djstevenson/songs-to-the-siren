const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

const { Url } = require('url');

// Get the registration page
const registration = client.page.registration();

// "Create test user" page
const testUser = client.page.testUser();


Given(/^I open the registration page$/,  () => {
    return client
        .url(registration.url())
        .waitForElementVisible('body', 1000);
});

When(/^I click on the register button$/, () => {
    return registration.section.form.click('@submit');
});

Then(/^The "(.*?)" registration field has error: "(.*?)"$/, (field, error) => {
    const label = '@' + field + 'Error';
    return registration.section.form.assert.containsText(label, error);
});

When(/^I enter "(.*?)" as "(.*?)" registration field$/, (value, field) => {
    const label = '@' + field + 'Field';
    return registration.section.form.setValue(label, value);
});


