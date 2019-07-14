const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

const { Url } = require('url');

// Get the login page
const testEmail = client.page.testEmail();


Then(/^The user "(.*?)" has a (.*?) email$/,  (username, type) => {
    return client
        .url(testEmail.url(type, username))
        .waitForElementVisible('body', 1000);
});
