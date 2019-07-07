package com.ytfc.blog;

import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class SeleniumBase {
    protected WebDriver driver;

    public void clickText(String linkText) {
        driver.findElement(By.linkText(linkText)).click();
    }

    public int countItems(By selector) {
        driver.manage().timeouts().implicitlyWait(1, TimeUnit.SECONDS);
        var c = driver.findElements(selector).size();
        driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS);
        return c;
    }
}
