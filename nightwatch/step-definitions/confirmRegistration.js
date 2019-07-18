const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

const viewTestEmail = client.page.viewTestEmail();

When(/^I click on the confirm link in the registration email for (.*)$/, (username) => {
    client
        .url(viewTestEmail.url('registration', username))
        .waitForElementVisible('body', 1000);
    viewTestEmail.section.urls.clickLink('@goodConfirm');
    return client.waitForElementVisible('body', 1000);
});

