import { client } from 'nightwatch-api';
import { Given, Then, When } from 'cucumber';

const viewTestEmail = client.page.viewTestEmail();

When(/^I click on the confirm link in the registration email for (.*)$/, (username) => {
    return client
        .url(testEmail.url('registration', username))
});

