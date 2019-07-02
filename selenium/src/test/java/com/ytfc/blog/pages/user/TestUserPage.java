package com.ytfc.blog.pages.user;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.pages.PageObject;


public class TestUserPage extends PageObject {
    public TestUserPage(WebDriver driver) {
        this.driver = driver;
    }

    public TestUserPage get(String name) {
        Helper.get(driver, "test/view_user/" + name);
        return this; // Chainable
    }

    public String getValue(String field) {
        WebElement el = driver.findElement(By.id("user-" + field));
        return el.getText();
    }

    public TestUserPage assertNotFound(String message) {
        Assert.assertEquals(getPageTitle(), "Test user not found", message);
        return this; // Chainable
    }

    public TestUserPage assertName(String expected, String message) {
        return assertValue("name", expected,  message);
    }

    public TestUserPage assertEmail(String expected, String message) {
        return assertValue("email", expected,  message);
    }

    public TestUserPage assertConfirmed(String expected, String message) {
        return assertValue("confirmed", expected,  message);
    }

    private TestUserPage assertValue(String valueName, String expected, String message) {
        Assert.assertEquals(getValue(valueName), expected,  message);
        return this; // Chainable
    }
}
