const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

const { Url } = require('url');

// Get the login page
const login = client.page.login();

// "Create test user" page
const createTestUser = client.page.createTestUser();


Given(/^I open the login page$/,  () => {
    return client
        .url(login.url())
        .waitForElementVisible('body', 1000);
});

When(/^I click on the login button$/, () => {
    return login.section.form.click('@submit');
});

// TODO Kinda repeated for all forms - can we factor it out?
//      Need to find how to pass form into step though.
Then(/^The (.*?) login field has error: (.*?)$/, (field, error) => {
    const label = '@' + field + 'Error';
    return login.section.form.assert.containsText(label, error);
});

When(/^I enter "(.*?)" into the (.*?) login field$/, (value, field) => {
    const label = '@' + field + 'Field';
    return login.section.form.setValue(label, value);
});

// Factor out this create-test-user cos we're gonna need it everywhere
Given(/^There is a user named "(.*?)"$/, (name) => {
    const lcUsername = name.toLowerCase();
    return client
        .url(createTestUser.url(lcUsername))
        .waitForElementVisible('body', 1000);
});


