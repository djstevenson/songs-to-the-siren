const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

const viewTestEmail = client.page.viewTestEmail();
const viewTestUser = client.page.viewTestUser();

When(/^I click on the confirm link in the registration email for (.*)$/, (username) => {
    return client
        .url(viewTestEmail.url('registration', username))
        .waitForElementVisible('body', 1000)
        .click('#email-urls-good-confirm > a')
        .waitForElementVisible('body', 1000);
});

Then(/^The user (.*?) is not confirmed$/, (username) => {
    return viewTestUser
        .navigate(username)
        .isConfirmed();
});
