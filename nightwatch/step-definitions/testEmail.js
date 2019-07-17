import { client } from 'nightwatch-api';
import { Given, Then, When } from 'cucumber';

import { Url } from 'url';

// Get the login page
const testEmail = client.page.testEmail();


Then(/^The user "(.*?)" has a (.*?) email$/,  (username, type) => {
    return client
        .url(testEmail.url(type, username))
        .waitForElementVisible('body', 1000);
});
