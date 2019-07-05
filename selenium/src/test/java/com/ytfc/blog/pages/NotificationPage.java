package com.ytfc.blog.pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

public class NotificationPage extends PageObject {
    public NotificationPage(WebDriver driver) {
        this.driver = driver;
    }

    @FindBy(css="h2.notification-title") WebElement notificationHeader;
    @FindBy(css="div.notification > p:first-child") WebElement notificationMessage;
    @FindBy(css=".flash-msg") WebElement flashMessage;
    
    public String getNotificationHeader() {
        return notificationHeader.getText();
    }

    public String getNotificationMessage() {
        return notificationMessage.getText();
    }

    public String getFlashMessage() {
        return flashMessage.getText();
    }

    public NotificationPage assertFlashMessage(String expected, String msg) {
        String actual = getFlashMessage();
        Assert.assertEquals(actual, expected, msg);

        return this; // Chainable
    }

    public NotificationPage assertNotificationHeader(String expected, String message) {
        Assert.assertEquals(getNotificationHeader(), expected, message + " (notification header)");
        assertPageTitle(expected, message + " (page title)");

        return this; // Chainable
    }

    public NotificationPage assertNotificationMessage(String expected, String message) {
        Assert.assertEquals(getNotificationMessage(), expected, message);

        return this; // Chainable
    }
}
