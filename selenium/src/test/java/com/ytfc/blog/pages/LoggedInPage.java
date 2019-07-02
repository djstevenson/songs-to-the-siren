package com.ytfc.blog.pages;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

public class LoggedInPage extends PageObject {
    @FindBy(css=".login-status > a") WebElement loggedInStatus;
    @FindBy(css=".login-status > span.user-name") WebElement loggedInUser;

    public LoggedInPage assertLoggedInAs(String expectedName, String message) {
        // If logged-in, we'll have a "Logout" link
        Assert.assertEquals(loggedInStatus.getText(), "Logout", message + " - status");
        Assert.assertEquals(loggedInUser.getText(), expectedName, message + " - user name");
        return this; // Chainable
    }

    public LoggedInPage assertLoggedOut(String message) {
        // If logged-out, we'll have a "Logint" link
        Assert.assertEquals(loggedInStatus.getText(), "Login", message + " - status");
        return this; // Chainable
    }
}
