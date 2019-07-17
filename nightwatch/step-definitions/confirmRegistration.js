const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

When(/^I click on the confirm link in the registration email for (.*)$/, (username) => {
    return client
        .url(testEmail.url('registration', username))
});

