const { client } =require('nightwatch-api');
const { Given, Then, When } =require('cucumber');

// Get the login page and form.
const login = client.page.login();
// const loginForm = login.section.loginForm;

Given(/^I open the login page$/,  () => {
    return client
        .url(login.url())
        .waitForElementVisible('body', 1000);
});

Then(/^The title is "(.*?)"$/, text => {
    return client.assert.title(text);
});

When(/^I click on the login button$/, () => {
    return login.section.loginForm.click('@submit').pause(1000);
});

Then(/^The "(.*?)" field has error: "(.*?)"$/, (field, error) => {
    const label = '@' + field + 'Error';
    return login.section.loginForm.assert.containsText(label, error);
});
