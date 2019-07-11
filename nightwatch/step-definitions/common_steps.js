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


