const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

const { Url } = require('url');

// Get the login page
const login = client.page.login();

// "Create test user" page
const testUser = client.page.testUser();


Given(/^I open the login page$/,  () => {
    return client
        .url(login.url())
        .waitForElementVisible('body', 1000);
});

Then(/^The title is "(.*?)"$/, text => {
    return client.assert.title(text);
});

When(/^I click on the login button$/, () => {
    return login.section.loginForm.click('@submit');
});

Then(/^The "(.*?)" field has error: "(.*?)"$/, (field, error) => {
    const label = '@' + field + 'Error';
    return login.section.loginForm.assert.containsText(label, error);
});

When(/^I enter "(.*?)" as "(.*?)" field$/, (value, field) => {
    const label = '@' + field + 'Field';
    return login.section.loginForm.setValue(label, value);
});

// Factor out this create-test-user cos we're gonna need it everywhere
Given(/^I create a user named "(.*?)"$/, (name) => {
    const lcUsername = name.toLowerCase();
    return client
        .url(testUser.url(lcUsername))
        .waitForElementVisible('body', 1000);
});


