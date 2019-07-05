package com.ytfc.blog.pages.user;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.pages.PageObject;


public class TestEmailPage extends PageObject {
    public TestEmailPage(WebDriver driver) {
        this.driver = driver;
    }

    public TestEmailPage get(String type, String username) {
        Helper.get(driver, "test/view_email/" +type + "/" + username);
        return this; // Chainable
    }

    public String getValue(String field) {
        WebElement el = driver.findElement(By.id("email-" + field));
        return el.getText();
    }

    public String getGoodConfirmURL() {
        return getValue("urls-good-confirm");
    }

    public String getGoodDeclineURL() {
        return getValue("urls-good-decline");
    }

    // which = "id" or "key"
    public String getBadConfirmURL(String which) {
        return getValue("urls-bad-confirm-" + which);
    }

    public String getBadDeclineURL(String which) {
        return getValue("urls-bad-decline-" + which);
    }

    public String getGoodResetURL() {
        return getValue("urls-good-reset");
    }

    public String getBadResetURL(String which) {
        return getValue("urls-bad-reset-" + which);
    }

    public String getDataString(String id) {
        return getValue("data-" + id);
    }
    
    public void assertDataExists(String id, String message) {
        String actual = getDataString(id);
        Assert.assertTrue(actual.length() > 0, message);
    }

    public void assertData(String expected, String id, String message) {
        String actual = getDataString(id);
        Assert.assertEquals(actual, expected, message);
    }

    public int getDataInt(String id) {
        return Integer.parseInt(getValue("data-" + id));
    }
    
    public void assertData(int expected, String id, String message) {
        int actual = getDataInt(id);
        Assert.assertEquals(actual, expected, message);
    }

    public void assertValidEmail(String username, String message) {
        String expected = "Test email - " + username.toLowerCase() + "@example.com";
        String actual = getPageTitle();
        Assert.assertEquals(actual, expected, message);
    }

    public void assertNotValidEmail(String message) {
        Assert.assertEquals(getPageTitle(), "Test email not found", message);
    }

}
