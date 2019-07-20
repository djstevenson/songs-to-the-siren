const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

var reverse = require('reverse-string');

// Page
const registration = client.page.registration();

Given(/^I open the registration page$/,  () => {
    return client
        .url(registration.url())
        .waitForElementVisible('body', 1000);
});

When(/^I click on the register button$/, () => {
    return registration.section.form.click('@submit');
});

Then(/^The (.*?) registration field has error: (.*?)$/, (field, error) => {
    const label = '@' + field + 'Error';
    return registration.section.form.assert.containsText(label, error);
});

When(/^I enter "(.*?)" into the (.*?) registration field$/, (value, field) => {
    const label = '@' + field + 'Field';
    return registration.section.form.setValue(label, value);
});


Given(/^I register a user named (.*?)$/,  (username) => {
    const lcName = username.toLowerCase();
    const email = lcName + '@example.com';
    const passwd = reverse(lcName);
    return registration.section.form.registerUser(lcName, email, passwd);
});

