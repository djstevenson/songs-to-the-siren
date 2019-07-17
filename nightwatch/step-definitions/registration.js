import { client } from 'nightwatch-api';
import { Given, Then, When } from 'cucumber';

import { reverse } from 'reverse-string';

// Get the registration page
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


Given(/^There is a new registered user named: (.*?)$/,  (username) => {
    const lcName = username.toLowerCase();
    const email = lcName + '@example.com';
    const passwd = reverse-String(lcName);
    return registration.section.form.register(lcName, email, passwd);
});

