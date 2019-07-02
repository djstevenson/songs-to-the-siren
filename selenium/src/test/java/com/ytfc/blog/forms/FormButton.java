package com.ytfc.blog.forms;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class FormButton {
    private WebDriver driver;
    private String buttonId;

    private WebElement el;

    protected FormButton(WebDriver driver, String buttonId) {
        this.driver = driver;
        this.buttonId = buttonId;
    }

    public synchronized WebElement getButtonElement() {
        if (el == null) {
            el = driver.findElement(By.id(buttonId));
        }
        return el;
    }

    public void click() {
        getButtonElement().click();
    }
}
