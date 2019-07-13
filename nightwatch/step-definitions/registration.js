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



