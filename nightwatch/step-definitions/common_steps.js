const { client } = require('nightwatch-api');
const { Given, Then, When } = require('cucumber');

const common = client.page.common();
const { Before } = require('cucumber');


Before(() => {
	client.maximizeWindow();
});

Then(/^The user is logged in$/, () => {
    return common.assertLoggedIn();
});

Then(/^The user is logged out$/, () => {
    return common.assertLoggedOut();
});

Then(/^The title is: (.*?)$/, text => {
    return client.assert.title(text);
});

Then(/^A flash message says: (.*?)$/, message => {
    return common.assertFlash(message);
});

Then(/^The registration-accepted page is showing$/, () => {
    return common.assertNotification("Thank you for your registration request");
});
