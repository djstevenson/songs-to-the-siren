const { client } =require('nightwatch-api');
const { Given, Then, When } =require('cucumber');

Given(/^I open Google`s search page$/, async () => {
    await client.url('http://google.com');
});

Then(/^the title is "(.*?)"$/, async text => {
    await client.assert.title(text);
});

Then(/^the Google search form exists$/, async () => {
    await client.assert.visible('input[name="q"]');
});

