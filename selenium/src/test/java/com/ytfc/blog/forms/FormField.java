package com.ytfc.blog.forms;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class FormField {
    private WebDriver driver;
    private String fieldId;
    private String errorId;
    private String expectedType;

    protected FormField(WebDriver driver, String type, String baseId) {
        this.driver = driver;
        this.expectedType = type;
        this.fieldId = baseId;
        this.errorId = "error-" + baseId;
    }

    public synchronized WebElement getFieldElement() {
        System.err.println("ID=" + fieldId);
        return driver.findElement(By.id(fieldId));
    }

    public synchronized WebElement getErrorElement() {
        return driver.findElement(By.id(errorId));
    }

    public void assertType(String message) {
        String actualType = getFieldElement().getAttribute("type");
        Assert.assertEquals(actualType, expectedType, message);
    }

    public String getErrorValue() {
        return getErrorElement().getText();
    }

    public void assertErrorValue(String expected, String message) {
        Assert.assertEquals(getErrorValue(), expected, message);
    }

    public void setValue(String value) {
        var e = getFieldElement();
        e.clear();
        e.sendKeys(value);
    }
}
