package com.ytfc.blog;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class SeleniumBase {
    protected WebDriver driver;

    public void clickText(String linkText) {
        driver.findElement(By.linkText(linkText)).click();
    }
}
