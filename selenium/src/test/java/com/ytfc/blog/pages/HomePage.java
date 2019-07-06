package com.ytfc.blog.pages;

import com.ytfc.blog.utility.Helper;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.testng.Assert;

public class HomePage extends PageObject {

    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    public HomePage get() {
        Helper.get(driver, "");

        assertPageTitle("Songs I’ll Never Tire of", "Page has correct title");

        return this; // Chainable
    }

    public HomePage assertSongCount(int expected, String msg) {
        int actual = getSongCount();
        Assert.assertEquals(actual, expected, msg);
        return this; // Chainable
    }

    public int getSongCount() {
        return countItems(By.cssSelector("section.song"));
    }

}
