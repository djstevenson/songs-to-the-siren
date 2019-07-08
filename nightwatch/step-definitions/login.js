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

// When(/^I click on the login button$/, async () => {
//     await login.section.loginForm.click('@submit');
// });

// Then(/^The name field has error: "(.*?)"$/, async error => {
//     await client.assert.value('@usernameError', error);
// });
